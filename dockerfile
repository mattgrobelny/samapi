# Use an official CUDA runtime as a parent image
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# Update package lists and install dependencies for Python 3.10
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y \
    python3.10 \
    python3.10-distutils \
    python3.10-venv \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y python3-pip git

# # Set environment variable to add Poetry's default path to PATH
# ENV POETRY_HOME="/root/.local"
# ENV PATH="$POETRY_HOME/bin:$PATH"

# # Install Poetry using the recommended method
# RUN pip install poetry

# # Copy only pyproject.toml to install dependencies
# COPY pyproject.toml ./

# # Install dependencies without poetry.lock
# RUN poetry config virtualenvs.create false && \
#     poetry install --no-root

# Copy requirements.txt to image
COPY requirements.txt .
# Install dependencies
RUN pip3 install -r requirements.txt
RUN pip3 install git+https://github.com/ChaoningZhang/MobileSAM.git
RUN pip3 install --upgrade importlib-metadata
RUN pip3 install gdown
# Install dependencies with poetry
# RUN poetry install

# Verify installations
# RUN python3 --version && pip3 --version

# Install pip for Python 3.10
# RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

# Expose the port for the FastAPI server
EXPOSE 8000
# ARG PORT=${PORT}
# EXPOSE ${PORT}

# Set the environment variable for CUDA
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Pass down API key from environment variable
ENV API_KEY=${API_KEY}

COPY ./src/ ./src/

WORKDIR /src
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port 8000 --workers 2"]

