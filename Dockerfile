FROM python:3.11.10-slim-bullseye

ARG VERSION=0.1.0

ENV PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=300 \
  UV_COMPILE_BYTECODE=1 \
  UV_LINK_MODE=copy

# Install uv and its dependencies
RUN apt-get update && \
    apt-get install -y curl gcc gnupg && \
    apt-get clean && \
    curl -LsSf https://astral.sh/uv/0.5.1/install.sh | sh

# Set a working directory
WORKDIR /root

COPY pyproject.toml uv.lock /root/
# Install the project's dependencies using the lockfile and settings
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    /root/.local/bin/uv sync --frozen --no-dev

COPY ./dist/test_action-${VERSION}-py3-none-any.whl /root/

WORKDIR /app

ENV PATH="/root/.venv/bin:$PATH"

CMD ["python", "-c", "print('hello world')"]