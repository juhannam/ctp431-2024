# CTP431
Python Code repository for CTP431 Fundamentals of Computer Music


# Instruction to set up the course Conda virtual environment 
We manage all Python library packages under a Conda virtual environment named "ctp431". As a first step, please install the Python 3 version of Anaconda (https://repo.anaconda.com/). It will provide a cross-platform installation package. 

*** Windows Users: please use Linux running on Windows such as Ubuntu on Windows (https://ubuntu.com/tutorials/ubuntu-on-windows#1-overview) and then run Python on it ***

After you have installed conda, close any open terminals you might have. Then open a new terminal and run the following command:


1. Create a ctp431 environment with python 3.11 and install essential packages

   conda create -n ctp431 python=3.11 jupyter jupyterlab matplotlib

2. Activate the new environment:

    conda activate ctp431

3. Install IPython kernel so we can use this environment in jupyter notebook: 

    python -m ipykernel install --user --name ctp431

4. install librosa and lapack

    conda install -y -c conda-forge librosa \
    conda install conda-forge::liblapack

5. Run Jupyter Notebook 

   jupyter notebook 	

6. Go to the "practice" folder and open one of "*.ipynb" files 
 
7. To deactivate an active environment, use
    
   conda deactivate


