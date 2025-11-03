
# Adamantine Standard — Verification Makefile
# Usage:
#   make verify           # uses verify.config.json
#   make verify DOC=path/to/file.pdf LEDGER=ledger_entry.json
#   make hash DOC=path/to/file.pdf
#   make clean

PYTHON ?= python3
CONFIG ?= verify.config.json
DOC ?=
LEDGER ?=
EXPECTED ?=

# Helper to read values from config JSON using Python (portable)
define json_get
$(PYTHON) -c 'import json,sys; d=json.load(open("$(CONFIG)")); print(d.get("$(1)",""))'
endef

verify:
	@doc="$(DOC)"; ledger="$(LEDGER)"; expected="$(EXPECTED)"; \
	if [ -z "$$doc" ]; then doc="$$( $(call json_get,file) )"; fi; \
	if [ -z "$$ledger" ]; then ledger="$$( $(call json_get,ledger) )"; fi; \
	if [ -z "$$expected" ]; then expected="$$( $(call json_get,expected) )"; fi; \
	if [ -z "$$doc" ]; then echo "ERROR: no DOC provided and no file in $(CONFIG)"; exit 2; fi; \
	if [ ! -f "$$doc" ]; then echo "ERROR: DOC not found: $$doc"; exit 2; fi; \
	cmd="$(PYTHON) tools/verify_sha256.py $$doc"; \
	if [ -n "$$ledger" ]; then cmd="$$cmd --ledger $$ledger"; fi; \
	if [ -n "$$expected" ]; then cmd="$$cmd --expected $$expected"; fi; \
	echo "Running: $$cmd"; \
	$$cmd --output text

hash:
	@if [ -z "$(DOC)" ]; then echo "Usage: make hash DOC=path/to/file.pdf"; exit 2; fi; \
	echo "Hashing $(DOC)"; \
	shasum -a 256 "$(DOC)" | awk '{print $$1}'

clean:
	@rm -f repro_log.jsonl
	@echo "Cleaned repro log."
