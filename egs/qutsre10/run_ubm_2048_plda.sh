#!/bin/bash
# Copyright 2015   David Snyder
#           2015   Johns Hopkins University (Author: Daniel Garcia-Romero)
#           2015   Johns Hopkins University (Author: Daniel Povey)
# Apache 2.0.
#
# See README.txt for more info on data required.
# Results (EERs) are inline in comments below.
#
# This example script shows how to replace the GMM-UBM
# with a DNN trained for ASR. It also demonstrates the
# using the DNN to create a supervised-GMM.

. cmd.sh
. path.sh
#set -e
mfccdir=`pwd`/mfcc
vaddir=`pwd`/mfcc
trials_female=data/sre10_test_ubm_plda_female/trials
trials_male=data/sre10_test_ubm_plda_male/trials
trials=data/sre10_test_ubm_plda/trials

## Number of UBM components
num_components=2048


## Prepare the SRE 2010 evaluation data, coreext-coreext
#local/make_sre_2010_test.pl /work/SAIVT/NIST2010/ data/
#local/make_sre_2010_train.pl /work/SAIVT/NIST2010/ data/


## Prepare a collection of NIST SRE data prior to 2010.
#local/make_sre_test.sh data


## Prepare SWB for UBM and i-vector extractor training.
#local/make_swbd2_phase2.pl /work/SAIVT/swb2_p2 \
#                           data/swbd2_phase2_train
#local/make_swbd2_phase3.pl /work/SAIVT/swb2_p3 \
#                           data/swbd2_phase3_train
#local/make_swbd_cellular2.pl /work/SAIVT/swbcell \
#                             data/swbd_cellular2_train

#utils/combine_data.sh data/train \
#  data/swbd_cellular2_train \
#  data/swbd2_phase2_train data/swbd2_phase3_train data/sre





# Extract speaker recogntion features.
#steps/make_mfcc.sh --mfcc-config conf/mfcc.conf --nj 40 --cmd queue_fisher300_dev.pl \
#    data/train exp/make_mfcc /home/n8991707/working/kaldi_toolkit/egs/kaldi-speaker-recognition/data/mfcc
#steps/make_mfcc.sh --mfcc-config conf/mfcc.conf --nj 40 --cmd queue_fisher300_dev.pl \
#    data/sre exp/make_mfcc /home/n8991707/working/kaldi_toolkit/egs/kaldi-speaker-recognition/data/mfcc
#steps/make_mfcc.sh --mfcc-config conf/mfcc.conf --nj 40 --cmd queue_fisher300_dev.pl \
#    data/sre10_train exp/make_mfcc /home/n8991707/working/kaldi_toolkit/egs/kaldi-speaker-recognition/data/mfcc
#steps/make_mfcc.sh --mfcc-config conf/mfcc.conf --nj 40 --cmd queue_fisher300_dev.pl \
#    data/sre10_test exp/make_mfcc /home/n8991707/working/kaldi_toolkit/egs/kaldi-speaker-recognition/data/mfcc





#for name in sre sre10_train sre10_test train; do
#  utils/fix_data_dir.sh data/${name}
#done



## Compute VAD decisions. These will be shared across both sets of features.
#sid/compute_vad_decision.sh --nj 40 --cmd queue_fisher300_dev.pl \
#    data/train exp/make_vad /home/n8991707/working/kaldi_toolkit/egs/kaldi-speaker-recognition/data/mfcc
#sid/compute_vad_decision.sh --nj 40 --cmd queue_fisher300_dev.pl \
#    data/sre exp/make_vad /home/n8991707/working/kaldi_toolkit/egs/kaldi-speaker-recognition/data/mfcc
#sid/compute_vad_decision.sh --nj 40 --cmd queue_fisher300_dev.pl \
#    data/sre10_train exp/make_vad /home/n8991707/working/kaldi_toolkit/egs/kaldi-speaker-recognition/data/mfcc
#sid/compute_vad_decision.sh --nj 40 --cmd queue_fisher300_dev.pl \
#    data/sre10_test exp/make_vad /home/n8991707/working/kaldi_toolkit/egs/kaldi-speaker-recognition/data/mfcc



#for name in sre sre10_train sre10_test train; do
#  cp data/${name}/vad.scp data/${name}/vad.scp
#  cp data/${name}/utt2spk data/${name}/utt2spk
#  cp data/${name}/spk2utt data/${name}/spk2utt
#  utils/fix_data_dir.sh data/${name}
#done



## 2048 UBM based PLDA system
#mkdir data/train_ubm_plda
#cp -r data/train data/train_ubm_plda
#mkdir data/sre_ubm_plda
#cp -r data/sre data/sre_ubm_plda
#mkdir data/sre10_train_ubm_plda
#cp -r data/sre10_train data/sre10_train_ubm_plda
#mkdir data/sre10_test_ubm_plda
#cp -r data/sre10_test data/sre10_test_ubm_plda
#mkdir data/sre10_10sec_train_ubm_plda
#cp -r data/sre10_10sec_train data/sre10_10sec_train_ubm_plda
#mkdir data/sre10_10sec_test_ubm_plda
#cp -r data/sre10_10sec_test data/sre10_10sec_test_ubm_plda


## Reduce the amount of training data for the UBM.
#utils/subset_data_dir.sh data/train_ubm_plda 16000 data/train_ubm_plda_16k
#utils/subset_data_dir.sh data/train_ubm_plda 32000 data/train_ubm_plda_32k


#sid/train_diag_ubm.sh \
#    data/train_ubm_plda_32k $num_components \
#    exp/diag_ubm_$num_components

#sid/train_full_ubm.sh --remove-low-count-gaussians false \
#    data/train_ubm_plda_32k \
#    exp/diag_ubm_$num_components exp/full_ubm_$num_components

#sid/train_ivector_extractor_ubm_plda.sh \
#  --ivector-dim 600 \
#  --num-iters 5 exp/full_ubm_$num_components/final.ubm data/train_ubm_plda \
#  exp/extractor

#sid/extract_ivectors_ubm_plda.sh --cmd queue_fisher300.pl --nj 50 \
#  exp/extractor_ubm_plda data/sre10_train \
#  exp/ivectors_sre10_train_ubm_plda

#sid/extract_ivectors_ubm_plda.sh --cmd queue_fisher300.pl --nj 50 \
#  exp/extractor_ubm_plda data/sre10_test \
#  exp/ivectors_sre10_test_ubm_plda

#sid/extract_ivectors_ubm_plda.sh --cmd queue_fisher300.pl --nj 50 \
#  exp/extractor_ubm_plda data/sre \
#  exp/ivectors_sre_ubm_plda


#sid/extract_ivectors_ubm_plda.sh --cmd queue_fisher300.pl --nj 50 \
#  exp/extractor_ubm_plda data/sre10_10sec_train \
#  exp/ivectors_sre10_10sec_train_ubm_plda

#sid/extract_ivectors_ubm_plda.sh --cmd queue_fisher300.pl --nj 50 \
#  exp/extractor_ubm_plda data/sre10_10sec_test \
#  exp/ivectors_sre10_10sec_test_ubm_plda

# Separate the i-vectors into male and female partitions and calculate
# i-vector means used by the scoring scripts.
#local/scoring_common.sh data/sre_ubm_plda data/sre10_train_ubm_plda data/sre10_test_ubm_plda \
#  exp/ivectors_sre_ubm_plda exp/ivectors_sre10_train_ubm_plda exp/ivectors_sre10_test_ubm_plda

#local/scoring_common.sh data/sre_ubm_plda data/sre10_10sec_train_ubm_plda data/sre10_10sec_test_ubm_plda \
#  exp/ivectors_sre_ubm_plda exp/ivectors_sre10_10sec_train_ubm_plda exp/ivectors_sre10_10sec_test_ubm_plda

# Create gender dependent PLDA models and do scoring.
#local/plda_scoring.sh data/sre_ubm_plda_female data/sre10_train_ubm_plda_female data/sre10_test_ubm_plda_female \
#  exp/ivectors_sre_ubm_plda_female exp/ivectors_sre10_train_ubm_plda_female exp/ivectors_sre10_test_ubm_plda_female $trials_female local/scores_ubm_plda_dep_female

#local/plda_scoring.sh data/sre_ubm_plda_male data/sre10_train_ubm_plda_male data/sre10_test_ubm_plda_male \
#  exp/ivectors_sre_ubm_plda_male exp/ivectors_sre10_train_ubm_plda_male exp/ivectors_sre10_test_ubm_plda_male $trials_male local/scores_ubm_plda_dep_male

#mkdir -p local/scores_ubm_plda_dep_pooled
#cat local/scores_ubm_plda_dep_male/plda_scores local/scores_ubm_plda_dep_female/plda_scores \
#  > local/scores_ubm_plda_dep_pooled/plda_scores


for y in female male pooled; do
  eer=`compute-eer <(python local/prepare_for_eer.py $trials local/scores_ubm_plda_dep_${y}/plda_scores) \
2> /dev/null`
  echo "${y}: $eer"
done
