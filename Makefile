.PHONY: generate apply apply-in-dev verify-in-dev clean run

generate:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-generate.yaml -vvv

apply-in-dev:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-apply.yaml --extra-vars "stage=dev"

DEV_VS_STATS_PATH := "/mgmt/tm/ltm/virtual/~as3_openapi_dev~as3_vs_httpbin_proxy_app~as3_vs_httpbin_proxy_svc/stats"
DEV_VS_IP := "192.168.0.211"
test-in-dev:
	@echo "Checking dev VS status..."
	@if timeout 10 bash -c ' \
		until [ "$$(curl -sk -u admin:admin https://bigip.home.internal:8443$(DEV_VS_STATS_PATH) | \
		jq -r ".entries[\"https://localhost$(DEV_VS_STATS_PATH)\"].nestedStats.entries.\"status.availabilityState\".description")" = "available" ]; \
		do \
			sleep 1; \
		done' \
	; then \
		echo "Success: dev VS status is available"; \
	else \
		echo "Failed: dev VS status is NOT available"; \
		exit 1; \
	fi

	@echo "Send test traffic to dev VS"
	@curl --fail $(DEV_VS_IP)/headers

apply:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-apply.yaml

VS_STATS_PATH := "/mgmt/tm/ltm/virtual/~as3_openapi~as3_vs_httpbin_proxy_app~as3_vs_httpbin_proxy_svc/stats"
VS_IP := "192.168.0.201"
test:
	@echo "Checking VS status..."
	@if timeout 10 bash -c ' \
		until [ "$$(curl -sk -u admin:admin https://bigip.home.internal:8443$(VS_STATS_PATH) | \
		jq -r ".entries[\"https://localhost$(VS_STATS_PATH)\"].nestedStats.entries.\"status.availabilityState\".description")" = "available" ]; \
		do \
			sleep 1; \
		done' \
	; then \
		echo "Success: VS status is available"; \
	else \
		echo "Failed: VS status is NOT available"; \
		exit 1; \
	fi

	@echo "Send test traffic to VS"
	@curl --fail $(VS_IP)/headers

clean:
	rm -rf .artifact

run: clean generate apply
