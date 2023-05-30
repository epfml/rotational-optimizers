BASE_DIR=$(pwd)
cd $BASE_DIR/submodules/timm

DATA_DIR=""

for seed in 10
do
    for lr in 3.2 6.4 12.8 25.6 51.2 0.1 0.2 0.4 0.8 1.6
    do
        PYTHONPATH=$PYTHONPATH:$BASE_DIR torchrun --nproc_per_node 1 train.py --output $BASE_DIR/output \
        --data-dir $DATA_DIR --dataset ImageFolder --num-classes 1000 --pin-mem --input-size 3 224 224 --workers 24 \
        --train-transforms 'RandomResizedCrop=(224,)' 'RandomHorizontalFlip=(0.5,)' PILToTensor='{}' \
        --test-transforms 'Resize=(256,)' 'CenterCrop=(224,)' 'PILToTensor={}' \
        --model resnet50 --model-kwargs zero_init_last=False --amp --channels-last \
        -b 256 --local-accumulation 128 --opt rvsgd --lr $lr --momentum 0.9 --weight-decay 1e-4 --sched cosine --sched-on-update --epochs 10 --warmup-lr 1e-6 --min-lr 1e-5 --warmup-epochs 0 --checkpoint-hist 5 \
        --log-wandb --wandb-kwargs project=melo_warmup name="\"i1k-rn50-nzi-b256x128-bn-rvsgd-lr$lr-s$seed\"" --log-wandb-extended --seed $seed
    done
done

for seed in 10
do
    for lr in 0.8 1.6 3.2 6.4 12.8 25.6 51.2 0.1 0.2 0.4
    do
        PYTHONPATH=$PYTHONPATH:$BASE_DIR torchrun --nproc_per_node 1 train.py --output $BASE_DIR/output \
        --data-dir $DATA_DIR --dataset ImageFolder --num-classes 1000 --pin-mem --input-size 3 224 224 --workers 24 \
        --train-transforms 'RandomResizedCrop=(224,)' 'RandomHorizontalFlip=(0.5,)' PILToTensor='{}' \
        --test-transforms 'Resize=(256,)' 'CenterCrop=(224,)' 'PILToTensor={}' \
        --model resnet50 --model-kwargs zero_init_last=False --amp --channels-last \
        -b 256 --local-accumulation 32 --opt rvsgd --lr $lr --momentum 0.9 --weight-decay 1e-4 --sched cosine --sched-on-update --epochs 10 --warmup-lr 1e-6 --min-lr 1e-5 --warmup-epochs 0 --checkpoint-hist 5 \
        --log-wandb --wandb-kwargs project=melo_warmup name="\"i1k-rn50-nzi-b256x32-bn-rvsgd-lr$lr-s$seed\"" --log-wandb-extended --seed $seed
    done
done

for seed in 10
do
    for lr in 0.1 0.2 0.4 0.8 1.6 3.2 6.4 12.8 25.6 51.2
    do
        PYTHONPATH=$PYTHONPATH:$BASE_DIR torchrun --nproc_per_node 1 train.py --output $BASE_DIR/output \
        --data-dir $DATA_DIR --dataset ImageFolder --num-classes 1000 --pin-mem --input-size 3 224 224 --workers 24 \
        --train-transforms 'RandomResizedCrop=(224,)' 'RandomHorizontalFlip=(0.5,)' PILToTensor='{}' \
        --test-transforms 'Resize=(256,)' 'CenterCrop=(224,)' 'PILToTensor={}' \
        --model resnet50 --model-kwargs zero_init_last=False --amp --channels-last \
        -b 256 --local-accumulation 8 --opt rvsgd --lr $lr --momentum 0.9 --weight-decay 1e-4 --sched cosine --sched-on-update --epochs 10 --warmup-lr 1e-6 --min-lr 1e-5 --warmup-epochs 0 --checkpoint-hist 5 \
        --log-wandb --wandb-kwargs project=melo_warmup name="\"i1k-rn50-nzi-b256x8-bn-rvsgd-lr$lr-s$seed\"" --log-wandb-extended --seed $seed
    done
done
