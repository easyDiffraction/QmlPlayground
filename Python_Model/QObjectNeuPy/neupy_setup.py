#!/usr/bin/env python

from setuptools import setup, find_packages

setup(name='neupy',
      version='1.0',
      description='PNPD data analysis',
      url = 'https://github.com/ikibalin/neupy',
      author='Iurii Kibalin',
      author_email='iurii.kibalin@cea.fr',
      license = 'MIT',
      keywords = 'Polarized Neutron Diffraction Data Analysis',
      packages = find_packages(),
      package_data={'': ['./**/*']}
      )