FROM --platform=x86_64 public.ecr.aws/lambda/python:3.12

# Copy requirements.txt
COPY requirements.txt ${LAMBDA_TASK_ROOT}

# Install the specified packages
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

RUN dnf update -y && \
    dnf install -y tar gzip bzip2 xz

RUN curl -O https://www.ks.uiuc.edu/Research/vmd/alpha/vmd-1.9.4a55.bin.LINUXAMD64-CUDA102-OptiX650-OSPRay185-RTXRTRT.opengl.tar.gz
RUN tar -xzf vmd-1.9.4a55.bin.LINUXAMD64-CUDA102-OptiX650-OSPRay185-RTXRTRT.opengl.tar.gz 

RUN dnf install -y perl libXinerama mesa-libGL libXi 

RUN cd vmd-1.9.4a55 && \
    ./configure && \
    cd src && \
    make install

# Copy function code
COPY *.py ${LAMBDA_TASK_ROOT}/
COPY *.tcl ${LAMBDA_TASK_ROOT}/
COPY *.txt ${LAMBDA_TASK_ROOT}/
COPY *.fa ${LAMBDA_TASK_ROOT}/
COPY *.pdb ${LAMBDA_TASK_ROOT}/
#ADD parameters ${LAMBDA_TASK_ROOT}/parameters
ADD shared ${LAMBDA_TASK_ROOT}/shared
#ADD PDB ${LAMBDA_TASK_ROOT}/PDB
#ADD Transformation ${LAMBDA_TASK_ROOT}/Transformation

# Set the CMD to your handler
CMD [ "handler.handler" ]

# DOCS: https://docs.aws.amazon.com/lambda/latest/dg/python-image.html#python-image-instructions
# build using: docker build  -t docker-image:test .
# run using: docker run --rm -p 9000:8080 docker-image:test
# test using: curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{<BODY>}'
