---
title: Install Docker
description: Testing the install of docker

---
## Sample exercise

```yaml
type: NormalExercise
lang: python
xp: 100
skills: 2
key: ecaded3183
```


`@instructions`

`@hint`

`@pre_exercise_code`
```{python}
from nilearn import datasets
from nipype.interfaces.fsl import BET
subject_data = datasets.fetch_adhd(n_subjects=1, data_dir='./')
skullstrip = BET()
skullstrip.inputs.in_file = subject_data['func'][0]
skullstrip.inputs.out_file = 'test.nii.gz'
res = skullstrip.run()

```

`@sample_code`
```{python}

```

`@solution`
```{python}

```

`@sct`
```{python}

```
