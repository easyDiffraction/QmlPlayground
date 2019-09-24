from PySide2.QtCore import Qt, QObject, Signal, Slot, Property
from PySide2.QtGui import QStandardItemModel

import operator
from functools import reduce

import cryspy

import logging
logging.basicConfig(format="%(asctime)-15s [%(levelname)s] %(filename)s %(funcName)s [%(lineno)d]: %(message)s", level=logging.INFO)

class CryspyHandler(QObject):
    def __init__(self, main_rcif_path, parent=None):
        super().__init__(parent)
        self._cryspy_obj = cryspy.rhochi_read_file(main_rcif_path)
        self._project_dict = {}
        self.setProjectDictFromCryspyObj()
        logging.info(main_rcif_path)

    def setProjectDictFromCryspyObj(self):
        """..."""
        #logging.info("")

        # Set phases (sample model tab in GUI)
        # ------------------------------------

        phases_dict = {}

        for phase in self._cryspy_obj.crystals:

            # add phase label

            phases_dict[phase.label] = {}

            # add unit cell parameters

            phases_dict[phase.label]['cell'] = {}
            phases_dict[phase.label]['cell']['length_a'] = {
                'header': 'a (Å)',
                'tooltip': 'Unit-cell length of the selected structure in angstroms.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Icell_length_.html',
                'value': phase.cell.a.value,
                'error': phase.cell.a.sigma,
                'refine': phase.cell.a.refinement }
            phases_dict[phase.label]['cell']['length_b'] = {
                'header': 'b (Å)',
                'tooltip': 'Unit-cell length of the selected structure in angstroms.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Icell_length_.html',
                'value': phase.cell.b.value,
                'error': phase.cell.b.sigma,
                'refine': phase.cell.b.refinement }
            phases_dict[phase.label]['cell']['length_c'] = {
                'header': 'c (Å)',
                'tooltip': 'Unit-cell length of the selected structure in angstroms.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Icell_length_.html',
                'value': phase.cell.c.value,
                'error': phase.cell.c.sigma,
                'refine': phase.cell.c.refinement }
            phases_dict[phase.label]['cell']['angle_alpha'] = {
                'header': 'alpha (°)',
                'tooltip': 'Unit-cell angle of the selected structure in degrees.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Icell_angle_.html',
                'value': phase.cell.alpha.value,
                'error': phase.cell.alpha.sigma,
                'refine': phase.cell.alpha.refinement }
            phases_dict[phase.label]['cell']['angle_beta'] = {
                'header': 'beta (°)',
                'tooltip': 'Unit-cell angle of the selected structure in degrees.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Icell_angle_.html',
                'value': phase.cell.beta.value,
                'error': phase.cell.beta.sigma,
                'refine': phase.cell.beta.refinement }
            phases_dict[phase.label]['cell']['angle_gamma'] = {
                'header': 'gamma (°)',
                'tooltip': 'Unit-cell angle of the selected structure in degrees.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Icell_angle_.html',
                'value': phase.cell.gamma.value,
                'error': phase.cell.gamma.sigma,
                'refine': phase.cell.gamma.refinement }

            # add space group

            phases_dict[phase.label]['space_group'] = {}
            phases_dict[phase.label]['space_group']['crystal_system'] = {
                'header': 'Crystal system',
                'tooltip': 'The name of the system of geometric crystal classes of space groups (crystal system) to which the space group belongs.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Ispace_group_crystal_system.html',
                'value': phase.cell.bravais_lattice }
            phases_dict[phase.label]['space_group']['space_group_name_H-M_alt'] = {
                'header': 'Symbol',
                'tooltip': 'The Hermann-Mauguin symbol of space group.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Ispace_group_name_H-M_alt.html',
                'value': phase.space_group.spgr_given_name }
            phases_dict[phase.label]['space_group']['space_group_IT_number'] = {
                'header': 'Number',
                'tooltip': 'The number as assigned in International Tables for Crystallography Vol. A.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Ispace_group_crystal_system.html',
                'value': phase.space_group.spgr_number }
            phases_dict[phase.label]['space_group']['origin_choice'] = {
                'header': 'Setting',
                'tooltip': '',
                'url': '',
                'value': phase.space_group.spgr_choice }

            # add atom sites label

            phases_dict[phase.label]['atom_site'] = {}
            for label in phase.atom_site.label:
                phases_dict[phase.label]['atom_site'][label] = {}
                #phases_dict[phase.label]['atom_site'][label]['label'] = {
                #'header': 'Label',
                #'tooltip': 'A unique identifier for a particular site in the crystal.',
                #'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_label.html',
                #}

            # add atom site type symbol

            for label, type_symbol in zip(phase.atom_site.label, phase.atom_site.type_symbol):
                phases_dict[phase.label]['atom_site'][label]['type_symbol'] = {
                    'header': 'Atom',
                    'tooltip': 'A code to identify the atom species occupying this site.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_type_symbol.html',
                    'value': type_symbol }

            # add atom site coordinates

            for label, x, y, z in zip(phase.atom_site.label, phase.atom_site.x, phase.atom_site.y, phase.atom_site.z):
                phases_dict[phase.label]['atom_site'][label]['fract_x'] = {
                    'header': 'x',
                    'tooltip': 'Atom-site coordinate as fractions of the unit cell length.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_fract_.html',
                    'value': x.value,
                    'error': x.sigma,
                    'refine': x.refinement }
                phases_dict[phase.label]['atom_site'][label]['fract_y'] = {
                    'header': 'y',
                    'tooltip': 'Atom-site coordinate as fractions of the unit cell length.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_fract_.html',
                    'value': y.value,
                    'error': y.sigma,
                    'refine': y.refinement }
                phases_dict[phase.label]['atom_site'][label]['fract_z'] = {
                    'header': 'z',
                    'tooltip': 'Atom-site coordinate as fractions of the unit cell length.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_fract_.html',
                    'value': z.value,
                    'error': z.sigma,
                    'refine': z.refinement }

            # add atom site occupancy

            for label, occupancy in zip(phase.atom_site.label, phase.atom_site.occupancy):
                phases_dict[phase.label]['atom_site'][label]['occupancy'] = {
                    'header': 'Occupancy',
                    'tooltip': 'The fraction of the atom type present at this site.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_occupancy.html',
                    'value': occupancy.value,
                    'error': occupancy.sigma,
                    'refine': occupancy.refinement }

            # add atom site ADP type

            for label, adp_type in zip(phase.atom_site.label, phase.atom_site.adp_type):
                phases_dict[phase.label]['atom_site'][label]['adp_type'] = {
                    'header': 'Type',
                    'tooltip': 'A standard code used to describe the type of atomic displacement parameters used for the site.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_adp_type.html',
                    'value': adp_type }

            # add isotropic ADP

            for label, b_iso in zip(phase.atom_site.label, phase.atom_site.b_iso):
                phases_dict[phase.label]['atom_site'][label]['B_iso_or_equiv'] = {
                    'header': 'Biso',
                    'tooltip': 'Isotropic atomic displacement parameter, or equivalent isotropic atomic displacement parameter, B(equiv), in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_B_iso_or_equiv.html',
                    'value': b_iso.value,
                    'error': b_iso.sigma,
                    'refine': b_iso.refinement }

            # add anisotropic ADP

            for label, u_11, u_22, u_33, u_12, u_13, u_23 in zip(phase.atom_site_aniso.label,
                phase.atom_site_aniso.u_11, phase.atom_site_aniso.u_22, phase.atom_site_aniso.u_33,
                phase.atom_site_aniso.u_12, phase.atom_site_aniso.u_13, phase.atom_site_aniso.u_23):
                phases_dict[phase.label]['atom_site'][label]['u_11'] = {
                    'header': 'U11',
                    'tooltip': 'Anisotropic atomic displacement component in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_aniso_U_.html',
                    'value': u_11.value,
                    'error': u_11.sigma,
                    'refine': u_11.refinement }
                phases_dict[phase.label]['atom_site'][label]['u_22'] = {
                    'header': 'U22',
                    'tooltip': 'Anisotropic atomic displacement component in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_aniso_U_.html',
                    'value': u_22.value,
                    'error': u_22.sigma,
                    'refine': u_22.refinement }
                phases_dict[phase.label]['atom_site'][label]['u_33'] = {
                    'header': 'U33',
                    'tooltip': 'Anisotropic atomic displacement component in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_aniso_U_.html',
                    'value': u_33.value,
                    'error': u_33.sigma,
                    'refine': u_33.refinement }
                phases_dict[phase.label]['atom_site'][label]['u_12'] = {
                    'header': 'U12',
                    'tooltip': 'Anisotropic atomic displacement component in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_aniso_U_.html',
                    'value': u_12.value,
                    'error': u_12.sigma,
                    'refine': u_12.refinement }
                phases_dict[phase.label]['atom_site'][label]['u_13'] = {
                    'header': 'U13',
                    'tooltip': 'Anisotropic atomic displacement component in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_aniso_U_.html',
                    'value': u_13.value,
                    'error': u_13.sigma,
                    'refine': u_13.refinement }
                phases_dict[phase.label]['atom_site'][label]['u_23'] = {
                    'header': 'U23',
                    'tooltip': 'Anisotropic atomic displacement component in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_aniso_U_.html',
                    'value': u_23.value,
                    'error': u_23.sigma,
                    'refine': u_23.refinement }

        # Set experiments (Experimental data tab in GUI)
        # ----------------------------------------------

        experiments_dict = {}

        for experiment in self._cryspy_obj.experiments:

            # add experiment label

            experiments_dict[experiment.label] = {}

            # add main parameters

            experiments_dict[experiment.label]['wavelength'] = {
                'header': 'Wavelength (Å)',
                'tooltip': '',
                'url': '',
                'value': experiment.wavelength }
            experiments_dict[experiment.label]['offset'] = {
                'header': '',
                'tooltip': '',
                'url': '',
                'value': experiment.offset.value,
                'error': experiment.offset.sigma,
                'refine': experiment.offset.refinement }

            # add background

            experiments_dict[experiment.label]['background'] = []
            for ttheta, intensity in zip(experiment.background.ttheta, experiment.background.intensity):
                experiments_dict[experiment.label]['background'].append({
                    'ttheta': ttheta,
                    'intensity': {
                        'value': intensity.value,
                        'error': intensity.sigma,
                        'refine': intensity.refinement
                    }
                })

            # add instrument resolution

            experiments_dict[experiment.label]['resolution'] = {}
            experiments_dict[experiment.label]['resolution']['u'] = {
                'header': 'U',
                'tooltip': '',
                'url': '',
                'value': experiment.resolution.u.value,
                'error': experiment.resolution.u.sigma,
                'refine': experiment.resolution.u.refinement }
            experiments_dict[experiment.label]['resolution']['v'] = {
                'header': 'V',
                'tooltip': '',
                'url': '',
                'value': experiment.resolution.v.value,
                'error': experiment.resolution.v.sigma,
                'refine': experiment.resolution.v.refinement }
            experiments_dict[experiment.label]['resolution']['w'] = {
                'header': 'W',
                'tooltip': '',
                'url': '',
                'value': experiment.resolution.w.value,
                'error': experiment.resolution.w.sigma,
                'refine': experiment.resolution.w.refinement }
            experiments_dict[experiment.label]['resolution']['x'] = {
                'header': 'X',
                'tooltip': '',
                'url': '',
                'value': experiment.resolution.x.value,
                'error': experiment.resolution.x.sigma,
                'refine': experiment.resolution.x.refinement }
            experiments_dict[experiment.label]['resolution']['y'] = {
                'header': 'Y',
                'tooltip': '',
                'url': '',
                'value': experiment.resolution.y.value,
                'error': experiment.resolution.y.sigma,
                'refine': experiment.resolution.y.refinement }

            # add measured data points

            experiments_dict[experiment.label]['measured'] = {}
            experiments_dict[experiment.label]['measured']['ttheta'] = experiment.meas.ttheta.tolist()
            experiments_dict[experiment.label]['measured']['up'] = experiment.meas.up.tolist()
            experiments_dict[experiment.label]['measured']['up_sigma'] = experiment.meas.up_sigma.tolist()
            experiments_dict[experiment.label]['measured']['down'] = experiment.meas.down.tolist()
            experiments_dict[experiment.label]['measured']['down_sigma'] = experiment.meas.down_sigma.tolist()

        # Set calculated data (depends on phases and experiments from above)
        # ------------------------------------------------------------------

        calculations_dict = {}

        # add statistical info

        for experiment in self._cryspy_obj.experiments:

            # add experiment label

            calculations_dict[experiment.label] = {}

            # get calculated chi squared and number of data points used for refinement

            chi_sq, n_res = experiment.calc_chi_sq(self._cryspy_obj.crystals)

            # add main parameters

            calculations_dict[experiment.label]['chi_squared'] = {
                'header': '',
                'tooltip': '',
                'url': '',
                'value': float(chi_sq) }
            calculations_dict[experiment.label]['n_res'] = {
                'header': '',
                'tooltip': '',
                'url': '',
                'value': int(n_res) }

            # get calculated data

            calculated_pattern, bragg_peaks, _ = experiment.calc_profile(experiment.meas.ttheta, self._cryspy_obj.crystals)

            # add Bragg peaks

            calculations_dict[experiment.label]['bragg_peaks'] = {}
            for index, crystal in enumerate(self._cryspy_obj.crystals):
                calculations_dict[experiment.label]['bragg_peaks'][crystal.label] = {
                    'h': bragg_peaks[index].h.tolist(),
                    'k': bragg_peaks[index].k.tolist(),
                    'l': bragg_peaks[index].l.tolist(),
                    'ttheta': bragg_peaks[index].ttheta.tolist()
                }

            # add calculated diffraction pattern

            calculations_dict[experiment.label]['calculated_pattern'] = {
                'ttheta': calculated_pattern.ttheta.tolist(),
                'up_total': calculated_pattern.up_total.tolist(),
                'down_total': calculated_pattern.down_total.tolist()
            }

        # Set application state
        # ---------------------

        app_dict = {
            'name': 'easyDiffraction',
            'version': '0.3.1',
            'url': 'http://easydiffraction.github.io'
        }

        # Set additional project info
        # ---------------------------

        info_dict = {
            'name': 'Fe3O4',
            'keywords': ['neutron diffraction', 'powder', '1d'],
            'created_date': '',
            'last_modified_date': ''
        }

        # Combine all the data to one project dictionary
        # ----------------------------------------------

        self._project_dict = {
            'info': info_dict,
            'app': app_dict,
            'phases': phases_dict,
            'experiments': experiments_dict,
            'calculations': calculations_dict,
        }
        #logging.info("")

    def getByPath(self, keys):
        """Access a nested object in root by key sequence."""
        return reduce(operator.getitem, keys, self._project_dict)

    def setByPath(self, keys, value):
        """Get a value in a nested object in root by key sequence."""
        #logging.info("")
        self.getByPath(keys[:-1])[keys[-1]] = value
        #logging.info("")

    def phasesCount(self):
        """Returns number of phases in the project."""
        return len(self._project_dict['phases'].keys())

    def experimentsCount(self):
        """Returns number of experiments in the project."""
        return len(self._project_dict['experiments'].keys())

    def phasesIds(self):
        """Returns labels of the phases in the project."""
        return list(self._project_dict['phases'].keys())

    def experimentsIds(self):
        """Returns labels of the experiments in the project."""
        return list(self._project_dict['experiments'].keys())

    def asDict(self):
        """Return data dict."""
        return self._project_dict

    projectDictChanged = Signal()

    def refine(self):
        """refinement ..."""
        #logging.info("")
        res = self._cryspy_obj.refine()
        logging.info(res)
        #logging.info("")
        self.setProjectDictFromCryspyObj()
        #logging.info("")
        self.projectDictChanged.emit()
        return {
            "refinement_message":res.message,
            #"num_refined_parameters":num_refined_parameters,
            #"started_chi_sq":started_chi_sq,
            "nfev":res.nfev,
            "nit":res.nit,
            "njev":res.njev,
            "final_chi_sq":res.fun,
            #"refinement_time":refinement_time
         }
        #logging.info("")
