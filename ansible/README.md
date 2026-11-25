# ansible

Manages Docker and the compose stacks on the VPS and the home server.
Compose files live in `../stacks/`; `inventory/host_vars/<host>.yml` says which
stacks run where.

```
ansible/
  site.yml                  # docker role, then stacks role
  inventory/
    hosts.yml
    group_vars/all.yml
    host_vars/{vps,homelab}.yml
  roles/
    docker/                 # installs Docker + Compose v2 if missing
    stacks/                 # copies compose files, writes .env, runs compose up
```

## Setup

```sh
cd ansible
ansible-galaxy collection install -r requirements.yml
```

## Usage

Always preview first. Add `-K` if sudo asks for a password.

```sh
ansible-playbook site.yml --limit vps --check --diff -K
ansible-playbook site.yml --limit vps -K
ansible-playbook site.yml --limit vps -e stacks_only=vaultwarden -K
ansible-playbook site.yml --tags docker -K
```

## Moving an existing stack over

1. On the host, run `docker compose ls` and `docker volume ls`. Compose names
   volumes `<project>_<volume>`, so the project name must match what the stack
   already runs under or it will get new, empty volumes. Set it in
   `stacks_project_names` in the host's `host_vars` file if it differs from the
   stack's folder name.
2. Stop the stack in whatever currently runs it (for example Portainer).
   Do not delete it or its volumes. Two deployers on one stack will clash on
   container names and ports.
3. Deploy one stack: `-e stacks_only=<name>`.

Image updates are left to Watchtower, so images are only pulled when missing
(`stacks_pull: missing`).

## Secrets

The compose files use `${VAR}` placeholders. Put values in `stacks_env`
(`stack -> {KEY: value}`) in an encrypted vars file, not in plain host_vars.
They are written to `<stacks_dir>/<stack>/.env` with mode 0600.
