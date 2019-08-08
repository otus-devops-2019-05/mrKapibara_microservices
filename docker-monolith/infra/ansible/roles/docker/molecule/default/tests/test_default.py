import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

def test_pip_instaled(host):
    assert host.run('pip --version').stderr == ""

def test_python_docker(host):
    assert "docker" in host.run('pip freeze | grep docker').stdout

def test_docker_service(host):
    docker = host.service("docker")
    assert docker.is_running
    assert docker.is_enabled
