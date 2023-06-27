generate:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-generate.yaml

apply-in-test:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-apply.yaml --extra-vars "stage=test"

apply:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-apply.yaml

clean:
	rm -rf .artifact

run: clean generate apply
