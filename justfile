default:
    @just --list

build:
    uv lock && uv build --wheel --out-dir dist

clean:
    rm -rf .venv dist *egg-info && uv cache clean
