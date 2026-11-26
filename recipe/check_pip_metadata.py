import importlib.metadata
import json
import subprocess
import sys

expected_version = sys.argv[1]
distribution = importlib.metadata.distribution("usd-exchange")
assert distribution.metadata["Name"] == "usd-exchange"
assert distribution.version == expected_version
assert distribution.read_text("INSTALLER").strip() == "conda"

packages = json.loads(subprocess.check_output(
    [sys.executable, "-m", "pip", "list", "--format=json", "--disable-pip-version-check"],
    text=True,
))
assert any(
    package["name"] == "usd-exchange" and package["version"] == expected_version
    for package in packages
), packages
print(f"pip list reports usd-exchange {expected_version}")
