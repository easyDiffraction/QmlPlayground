import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtDataVisualization 1.12

import easyInterface.App 1.0 as InterfaceApp
import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.Animations 1.0 as InterfaceAnimations

InterfaceApp.StructureView {

    // Unit cell
    Scatter3DSeries {
        mesh: Abstract3DSeries.MeshSphere
        //meshSmooth: true
        itemSize: 0.03
        baseColor: Material.color(Material.Grey)
        colorStyle: Theme3D.ColorStyleUniform
        ItemModelScatterDataProxy {
            itemModel: ListModel {
                id: cellBox
            }
            xPosRole: "x"
            yPosRole: "y"
            zPosRole: "z"
        }
    }

    // Ce atom
    Scatter3DSeries {
        mesh: Abstract3DSeries.MeshSphere
        itemSize: 0.65
        baseColor: InterfaceGlobals.Color.green
        colorStyle: Theme3D.ColorStyleUniform
        ItemModelScatterDataProxy {
            itemModel: ListModel {
                id: posCe
            }
            xPosRole: "x"
            yPosRole: "y"
            zPosRole: "z"
        }
    }

    // Cu1 atom
    Scatter3DSeries {
        mesh: Abstract3DSeries.MeshSphere
        itemSize: 0.45
        baseColor: InterfaceGlobals.Color.red
        ItemModelScatterDataProxy {
            itemModel: ListModel {
                id: posCu1
            }
            xPosRole: "x"
            yPosRole: "y"
            zPosRole: "z"
        }
    }

    // Cu2 atom
    Scatter3DSeries {
        mesh: Abstract3DSeries.MeshSphere
        itemSize: 0.45
        baseColor: InterfaceGlobals.Color.red
        ItemModelScatterDataProxy {
            itemModel: ListModel {
                id: posCu2
            }
            xPosRole: "x"
            yPosRole: "y"
            zPosRole: "z"
        }
    }

    // Al atom
    Scatter3DSeries {
        mesh: Abstract3DSeries.MeshSphere
        itemSize: 0.55
        baseColor: InterfaceGlobals.Color.blue
        ItemModelScatterDataProxy {
            itemModel: ListModel {
                id: posAl
            }
            xPosRole: "x"
            yPosRole: "y"
            zPosRole: "z"
        }
    }

    // Add scatter series
    Component.onCompleted: {
        const a = 4.25678
        const b = a
        const c = 10.63388

        // Unit cell
        const n = 1000
        for (var i = 0; i <= n; i++) {
            cellBox.append({
                               "x": i / n * a,
                               "y": 0.0 * b,
                               "z": 0.0 * c
                           })
            cellBox.append({
                               "x": i / n * a,
                               "y": 1.0 * b,
                               "z": 0.0 * c
                           })
            cellBox.append({
                               "x": i / n * a,
                               "y": 0.0 * b,
                               "z": 1.0 * c
                           })
            cellBox.append({
                               "x": i / n * a,
                               "y": 1.0 * b,
                               "z": 1.0 * c
                           })
            cellBox.append({
                               "x": 0.0 * a,
                               "y": i / n * b,
                               "z": 0.0 * c
                           })
            cellBox.append({
                               "x": 1.0 * a,
                               "y": i / n * b,
                               "z": 0.0 * c
                           })
            cellBox.append({
                               "x": 0.0 * a,
                               "y": i / n * b,
                               "z": 1.0 * c
                           })
            cellBox.append({
                               "x": 1.0 * a,
                               "y": i / n * b,
                               "z": 1.0 * c
                           })
            cellBox.append({
                               "x": 0.0 * a,
                               "y": 0.0 * b,
                               "z": i / n * c
                           })
            cellBox.append({
                               "x": 1.0 * a,
                               "y": 0.0 * b,
                               "z": i / n * c
                           })
            cellBox.append({
                               "x": 0.0 * a,
                               "y": 1.0 * b,
                               "z": i / n * c
                           })
            cellBox.append({
                               "x": 1.0 * a,
                               "y": 1.0 * b,
                               "z": i / n * c
                           })
        }

        // Ce atom
        posCe.append({
                         "x": 0.0 * a,
                         "y": 0.0 * b,
                         "z": 0.0 * c
                     })
        posCe.append({
                         "x": 1.0 * a,
                         "y": 0.0 * b,
                         "z": 0.0 * c
                     })
        posCe.append({
                         "x": 0.0 * a,
                         "y": 1.0 * b,
                         "z": 0.0 * c
                     })
        posCe.append({
                         "x": 1.0 * a,
                         "y": 1.0 * b,
                         "z": 0.0 * c
                     })
        posCe.append({
                         "x": 0.5 * a,
                         "y": 0.5 * b,
                         "z": 0.5 * c
                     })
        posCe.append({
                         "x": 0.0 * a,
                         "y": 0.0 * b,
                         "z": 1.0 * c
                     })
        posCe.append({
                         "x": 1.0 * a,
                         "y": 0.0 * b,
                         "z": 1.0 * c
                     })
        posCe.append({
                         "x": 0.0 * a,
                         "y": 1.0 * b,
                         "z": 1.0 * c
                     })
        posCe.append({
                         "x": 1.0 * a,
                         "y": 1.0 * b,
                         "z": 1.0 * c
                     })

        // Cu1 atom
        posCu1.append({
                          "x": 0.5 * a,
                          "y": 0.5 * b,
                          "z": 0.13224 * c
                      })
        posCu1.append({
                          "x": 0.0 * a,
                          "y": 0.0 * b,
                          "z": 0.63224 * c
                      })
        posCu1.append({
                          "x": 1.0 * a,
                          "y": 0.0 * b,
                          "z": 0.63224 * c
                      })
        posCu1.append({
                          "x": 0.0 * a,
                          "y": 1.0 * b,
                          "z": 0.63224 * c
                      })
        posCu1.append({
                          "x": 1.0 * a,
                          "y": 1.0 * b,
                          "z": 0.63224 * c
                      })

        // Cu2 atom
        posCu2.append({
                          "x": 0.5 * a,
                          "y": 0.5 * b,
                          "z": 0.90437 * c
                      })
        posCu2.append({
                          "x": 0.0 * a,
                          "y": 0.0 * b,
                          "z": 0.40437 * c
                      })
        posCu2.append({
                          "x": 1.0 * a,
                          "y": 0.0 * b,
                          "z": 0.40437 * c
                      })
        posCu2.append({
                          "x": 0.0 * a,
                          "y": 1.0 * b,
                          "z": 0.40437 * c
                      })
        posCu2.append({
                          "x": 1.0 * a,
                          "y": 1.0 * b,
                          "z": 0.40437 * c
                      })

        // Al atom
        posAl.append({
                         "x": 0.5 * a,
                         "y": 0.0 * b,
                         "z": 0.24981 * c
                     })
        posAl.append({
                         "x": 0.0 * a,
                         "y": 0.5 * b,
                         "z": 0.24981 * c
                     })
        posAl.append({
                         "x": 0.5 * a,
                         "y": 1.0 * b,
                         "z": 0.24981 * c
                     })
        posAl.append({
                         "x": 1.0 * a,
                         "y": 0.5 * b,
                         "z": 0.24981 * c
                     })
        posAl.append({
                         "x": 0.5 * a,
                         "y": 0.0 * b,
                         "z": 0.74981 * c
                     })
        posAl.append({
                         "x": 0.0 * a,
                         "y": 0.5 * b,
                         "z": 0.74981 * c
                     })
        posAl.append({
                         "x": 0.5 * a,
                         "y": 1.0 * b,
                         "z": 0.74981 * c
                     })
        posAl.append({
                         "x": 1.0 * a,
                         "y": 0.5 * b,
                         "z": 0.74981 * c
                     })
    }
}
