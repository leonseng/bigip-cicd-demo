include Makefile.*

generate:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-generate.yaml

apply:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-apply.yaml

apply-in-dev:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-apply.yaml --extra-vars "stage=dev"

clean:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-remove.yaml
	rm -rf .artifact

run: clean generate apply
