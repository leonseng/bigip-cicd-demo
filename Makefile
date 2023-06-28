.PHONY: generate apply apply-in-test verify-in-test clean run

generate:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-generate.yaml

apply-in-test:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-apply.yaml --extra-vars "stage=test"

TEST_VS_STATS_PATH := "/mgmt/tm/ltm/virtual/~as3_tenant_test~as3_app~as3_vs_httpbin_proxy/stats"
TEST_VIP := "192.168.0.200"
verify-in-test:
	@echo "Checking Test VS status..."
	@if timeout 10 bash -c ' \
		until [ "$$(curl -sk -u admin:admin https://bigip.home.internal:8443$(TEST_VS_STATS_PATH) | \
		jq -r ".entries[\"https://localhost$(TEST_VS_STATS_PATH)\"].nestedStats.entries.\"status.availabilityState\".description")" = "available" ]; \
		do \
			sleep 1; \
		done' \
	; then \
		echo "Success: Test VS status is available"; \
	else \
		echo "Failed: Test VS status is NOT available"; \
		exit 1; \
	fi

	@echo "Send test traffic to Test VS"
	@curl --fail $(TEST_VIP)/headers

apply:
	ansible-playbook -i inventory/inventory.ini playbooks/as3-config-apply.yaml

TEST_VS_STATS_PATH := "/mgmt/tm/ltm/virtual/~as3_tenant_test~as3_app~as3_vs_httpbin_proxy/stats"
TEST_VIP := "192.168.0.21"
verify:
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
	@curl --fail $(VIP)/headers

clean:
	rm -rf .artifact

run: clean generate apply
