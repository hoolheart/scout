# PyTorch Study

## Prepare

```shell
conda create -n pytorch python=3.9
conda activate pytorch
conda install pytorch torchvision torchaudio -c pytorch
conda install ipykernel matplotlib pandas
python -m ipykernel install --user --name pytorch
conda deactivate
```

For the platform with CUDA 11.7 (lastest on Aug 21, 2022),
the third line should be

```shell
conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
```

## Dive into Deep Learning

Use "Dive into Deep Learning" book to study PyTorch, download and install
related code:

```shell
curl https://d2l.ai/d2l-en.zip -o d2l-en.zip
unzip d2l-en.zip
# rm d2l-en.zip # remove downloaded zip optionally
rmdir mxnet
rmdir tensorflow
mv pytorch d2l-pytorch
cd d2l-pytorch
conda activate pytorch
pip install -e .
conda deactivate
```
