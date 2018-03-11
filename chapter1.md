---
title: Nipype Interface
description: >-
  Test out the nipype interface


---
## Using BET

```yaml
type: NormalExercise
lang: python
xp: 100
skills: 2
key: ecaded3183
```



`@instructions`
In Nipype, interfaces are python modules that allow you to use various external packages (e.g. FSL, SPM or FreeSurfer), even if they themselves are written in another programming language than python. Such an interface knows what sort of options an external program has and how to execute it.

To illustrate why interfaces are so useful, let's have a look at the brain extraction algorithm BET from FSL. 

I've downloaded a subject from the adhd project using [nilearn](http://nilearn.github.io/modules/generated/nilearn.datasets.fetch_adhd.html) and assigned the output (which is a dictionary) to subject_data.

`@hint`
run the code first so you can play with the res object

`@pre_exercise_code`
```{python}
from nilearn import datasets
import os
os.environ['PATH'] = '/usr/lib/fsl/5.0:/usr/lib/afni/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
os.environ['FSLDIR'] = '/usr/share/fsl/5.0'
os.environ['LD_LIBRARY_PATH'] = '/usr/lib/fsl/5.0:$LD_LIBRARY_PATH'
subject_data = datasets.fetch_adhd(n_subjects=1, data_dir='./', verbose=0)
```
`@sample_code`
```{python}
from nipype.interfaces.fsl import BET
skullstrip = BET()
skullstrip.inputs.in_file = subject_data['func'][0]
skullstrip.inputs.out_file = 'test.nii.gz'
res = skullstrip.run()

# set the out file to out_file
out_file = res.outputs.out_file

# print out_file

```
`@solution`
```{python}
from nipype.interfaces.fsl import BET
skullstrip = BET()
skullstrip.inputs.in_file = subject_data['func'][0]
skullstrip.inputs.out_file = 'test.nii.gz'
res = skullstrip.run()

# set the out file to out_file
out_file = res.outputs.out_file

# print out_file
print(out_file)
```
`@sct`
```{python}
# test the print function
test_function("print", args=[])
# general
success_msg('Great Work!')
```




