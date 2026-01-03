set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

default:
  @just --list

lint:
  ansible-lint

pre-commit: lint

check:
  @inventory="${RELEASY_INVENTORY:-inventory/hosts.yml}"; \
  vault_arg=""; \
  if [[ -n "${RELEASY_VAULT_PASSWORD_FILE:-}" ]]; then \
    vault_arg="--vault-password-file ${RELEASY_VAULT_PASSWORD_FILE}"; \
  fi; \
  ansible-playbook playbooks/site.yml --check --diff -i "$$inventory" $$vault_arg

run:
  @inventory="${RELEASY_INVENTORY:-inventory/hosts.yml}"; \
  vault_arg=""; \
  if [[ -n "${RELEASY_VAULT_PASSWORD_FILE:-}" ]]; then \
    vault_arg="--vault-password-file ${RELEASY_VAULT_PASSWORD_FILE}"; \
  fi; \
  ansible-playbook playbooks/site.yml -i "$$inventory" $$vault_arg
