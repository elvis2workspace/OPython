# -*- coding: utf-8 -*-

from CAppiumLibrary import CAppiumLibrary
import os


THIS_DIR = os.path.dirname(os.path.abspath(__file__))
execfile(os.path.join(THIS_DIR, 'version.py'))

__version__ = VERSION

class CustomLibrary(CAppiumLibrary):
    """
         这里也可以装x 的写上我们创建的CustomLibrary 如何如何。
    """
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = VERSION