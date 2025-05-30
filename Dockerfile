# Base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Step 1: Install system dependencies including Graphviz
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    libfuse2 \
    unzip \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    python3-pip \
    graphviz \
    && rm -rf /var/lib/apt/lists/*

# Step 2: Install Amazon Q CLI
RUN curl --proto '=https' --tlsv1.2 -sSf https://desktop-release.q.us-east-1.amazonaws.com/latest/amazon-q.deb -o amazon-q.deb \
    && apt-get update && apt-get install -y ./amazon-q.deb \
    && rm amazon-q.deb

# Step 3: Install uv and diagrams Python packages
RUN pip install uv diagrams

# Step 4: Add MCP configuration file
RUN mkdir -p /root/.aws/amazonq
COPY mcp.json /root/.aws/amazonq/mcp.json

# Step 5: Set environment to use uv executor
ENV UV_EXECUTOR=uv

# Step 6: Default command to run Q CLI
ENTRYPOINT ["q"]
CMD []
