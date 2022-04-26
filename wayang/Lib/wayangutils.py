# -*- coding=utf-8 -*-
from deepdiff import DeepDiff
import json


def respdiff(resp,expected,exclude):
    print(resp,expected,exclude)
    print(type(resp))
    print(type(expected))
    print(type(exclude))
    res = DeepDiff(resp,expected,exclude_paths=exclude)
    return res

    

