cd pysam
python setup.py install --prefix ~/software/tools/pythonlib

echo "pygraphviz"
git clone https://github.com/pygraphviz/pygraphviz.git
python setup.py install --prefix ~/software/tools/pythonlib

echo "pyvcf"
git clone https://github.com/JinfengChen/PyVCF.git
python setup.py install --prefix ~/software/tools/pythonlib

echo "memory_profiler"
pip install --install-option="--prefix=/rhome/cjinfeng/software/tools/pythonlib" -U memory_profiler
pip install --install-option="--prefix=/rhome/cjinfeng/software/tools/pythonlib" psutil

echo "multiprocess, better than multiprocessing, can replace the latter"
wget https://files.pythonhosted.org/packages/31/60/6d74caa02b54ca43092e745640c7d98f367f07160441682a01602ce00bc5/multiprocess-0.70.7.tar.gz
uz multiprocess-0.70.7.tar.gz 
cd multiprocess-0.70.7
python setup.py install --prefix ~/BigData/software/pythonlib

