# -*- mode: python ; coding: utf-8 -*-

block_cipher = None


a = Analysis(['pymodel4qml.py'],
             pathex=['/Users/andrewsazonov/Development/Projects/QmlPlayground/Python_Model/QObjectRhoChi'],
             binaries=[],
             datas=[('Examples', 'Examples'), ('f_api_rcif', 'f_api_rcif'), ('f_common', 'f_common'), ('f_crystal', 'f_crystal'), ('f_rcif', 'f_rcif'), ('f_rhochi_model', 'f_rhochi_model'), ('gui.qml', '.')],
             hiddenimports=[],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
          a.scripts,
          [],
          exclude_binaries=True,
          name='pymodel4qml',
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          console=False )
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas,
               strip=False,
               upx=True,
               upx_exclude=[],
               name='pymodel4qml')
app = BUNDLE(coll,
             name='pymodel4qml.app',
             icon=None,
             bundle_identifier=None)
