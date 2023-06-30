include Makefile.*

generate:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-generate.yaml

apply-in-dev:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-apply.yaml --extra-vars "stage=dev"

clean:
	rm -rf .artifact

run: clean generate apply
