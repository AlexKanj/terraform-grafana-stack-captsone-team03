.PHONY: init plan apply fetch-key deploy all destroy

ANSIBLE_DIR = ansible
TF_DIR      = terraform

init:
	cd $(TF_DIR) && terraform init \
		-backend-config="bucket=$(TF_STATE_BUCKET)" \
		-backend-config="region=$(AWS_DEFAULT_REGION)"

plan:
	cd $(TF_DIR) && terraform plan

apply:
	cd $(TF_DIR) && terraform apply -auto-approve

fetch-key:
	mkdir -p $(ANSIBLE_DIR)/.keys
	aws ssm get-parameter \
		--name /monitoring/ssh-private-key \
		--with-decryption \
		--query Parameter.Value \
		--output text > $(ANSIBLE_DIR)/.keys/monitoring.pem
	chmod 600 $(ANSIBLE_DIR)/.keys/monitoring.pem

deploy:
	cd $(ANSIBLE_DIR) && ansible-playbook playbooks/site.yml

all: init apply fetch-key deploy

destroy:
	cd $(TF_DIR) && terraform destroy
