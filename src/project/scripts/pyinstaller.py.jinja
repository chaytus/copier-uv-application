"""Generate a Application."""

import os
import subprocess
import sys
from pathlib import Path

import click
import toml
from dotenv import load_dotenv
from update_version import add_version, update_spec


def fixture(func):
    """Fixture decorator."""

    def wrapper(arch: str = "x86_64", version: str = "0.0.0", wd: Path | None = None):
        """Read the project config and set up support."""
        if not wd:
            wd = Path.cwd()
        config_path = Path(wd, "configs", "pyinstaller.toml")
        # Get the os platform
        platform = sys.platform

        # Get the path to the executable
        # print(sys.executable)
        python_path = Path(sys.executable)
        bin_path = python_path.parent

        # Load the config info and initialize the meta
        config = toml.load(config_path)

        func(platform, bin_path, config, arch, version)

    return wrapper


def translate(data: list, platform: str) -> list[str]:
    """Replace the `:` with `;` on windows."""
    seperator = ":" if platform == "darwin" else ";"
    return [item.replace(":", seperator) for item in data]


@fixture
def generate_spec_file(platform: str, bin_path: Path, config: dict, _arch: str, version: str):
    """Generate a Application."""
    application_name: str = config["project"]["name"]
    cmd: Path = Path(bin_path, "pyi-makespec")
    # Get the environment variables from the shell
    osx_code_sign: str | None = os.getenv("OSX_CODESIGN_IDENTITY")
    osx_bundle_id: str | None = os.getenv("OSX_BUNDLE_IDENTIFIER")
    print(f"Code Sign: {osx_code_sign}")
    print(f"Bundle ID: {osx_bundle_id}")

    args: list = []

    # Check if the spec file exists and delete it if it does
    spec_path = Path(f"{application_name}.spec")
    print(f"Removing {spec_path} if it exists")
    if spec_path.exists():
        spec_path.unlink()

    # Add the path to the cmd
    cmd = Path(bin_path, cmd)

    args += config["arguments"]["base"]
    args.append("--name=" + config["project"]["name"])
    args.append(
        "--icon="
        + (
            config["project"]["macos_icon"]
            if platform == "darwin"
            else config["project"]["windows_icon"]
        )
    )
    # args += translate(config["arguments"]["data"], platform)
    args += config["arguments"]["data"]

    args += config["arguments"]["exclude"]
    args += config["arguments"]["hidden"]

    if platform == "darwin" and osx_code_sign and osx_bundle_id:
        args.append(f"--codesign-identity={osx_code_sign}")
        args.append(f"--osx-bundle-identifier={osx_bundle_id}." + config["project"]["name"])
        args += config["arguments"]["macos"]
    elif platform == "win32":
        args += config["arguments"]["windows"]

    args.append(config["project"]["entry_point"])

    run_cmd(cmd, args)

    # Add the version number to the spec file
    if platform == "darwin":
        print("Adding version to spec file")
        add_version(application_name)
        print("Updating version to spec file")
        update_spec(application_name, version)


@fixture
def make_app(platform: str, bin_path: Path, config: dict, _arch: str, _version: str):
    """Generate the application with PyInstaller."""
    application_name: str = config["project"]["name"]
    cmd: Path = Path(bin_path, "pyinstaller")
    args: list = [
        "--clean",
        "-y",
    ]

    # Update the spec version number
    if platform == "darwin":
        update_spec(application_name)

    cmd = Path(bin_path, cmd)
    args.append(f"{application_name}.spec")

    run_cmd(cmd, args)


@fixture
def make_dmg(_platform: str, bin_path: Path, config: dict, arch: str, _version: str):
    """Generate the application with PyInstaller."""
    application_name: str = config["project"]["name"]
    cmd = Path(bin_path, "dmgbuild")
    args = [
        "-s",
        "configs/dmg-settings.json",
        f'"{application_name} Installation"',
        f"{application_name}_{arch}.dmg",
    ]
    run_cmd(cmd, args)


def run_cmd(cmd: Path, args: list[str]):
    """Run a command with the given arguments."""
    print(f"\n{'-' * 80}")
    print(f"Running command: {cmd} {' '.join(args)}")
    print(f"{'-' * 80}\n")
    subprocess.run([cmd, *args])


@click.command()
@click.option("-s", "--spec", is_flag=True, help="Generate the spec file")
@click.option("-a", "--app", is_flag=True, help="Make application")
@click.option("-d", "--dmg", is_flag=True, help="Make dmg file")
@click.option("-p", "--platform", default="x86_64", help="The architecture to build for")
@click.option("-v", "--version", default="0.0.0", help="The version of the application")
def main(
    spec: bool = False,
    app: bool = False,
    dmg: bool = False,
    platform: str = "x84_64",
    version: str = "0.0.0",
):
    """Update the version number in pyinstaller spec file and Info.plist file."""
    load_dotenv()

    if spec:
        generate_spec_file(version=version)
    if app:
        make_app(version=version)
    if dmg:
        make_dmg(arch=platform)


if __name__ == "__main__":
    main()
