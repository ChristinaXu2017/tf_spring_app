FROM jupyter/base-notebook

# Switch to root user to perform administrative tasks
USER root

# Install required tools
RUN apt-get update && apt-get install -y python3-venv gcc make build-essential git && apt-get clean

# Upgrade pip, setuptools, and wheel in the base environment
RUN python3 -m pip install --upgrade pip setuptools wheel && pip install s3contents

# Create virtual environments and install packages
RUN python3 -m venv /opt/venv/mRNAid && \
    /opt/venv/mRNAid/bin/pip install mRNAid ipykernel && \
    /opt/venv/mRNAid/bin/python -m ipykernel install --prefix=/usr/local --name mRNAid --display-name "Python (mRNAid)"

RUN python3 -m venv /opt/venv/vaxpress && \
    /opt/venv/vaxpress/bin/pip install vaxpress ipykernel && \
    /opt/venv/vaxpress/bin/python -m ipykernel install --prefix=/usr/local --name vaxpress --display-name "Python (vaxpress)"

# Ensure the necessary permissions are set
RUN chown -R $NB_UID:$NB_GID /usr/local/share/jupyter/kernels /opt/venv/mRNAid /opt/venv/vaxpress

# Set a password for the root user
RUN echo 'root:password' | chpasswd

# Give jovyan user sudo permissions without password
RUN echo "jovyan ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Create the .jupyter directory and ensure jovyan user has ownership
RUN mkdir -p /home/jovyan/.jupyter && chown jovyan:users /home/jovyan/.jupyter

# Copy customer config to location where jupyter will load it
COPY jupyter_server_config.py /home/jovyan/.jupyter/

# Switch back to the default user
USER jovyan

# Expose the Jupyter port
EXPOSE 8888

# Start Jupyter Notebook automatically
CMD ["start-notebook.sh"]
