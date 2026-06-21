import { PressKeysBean } from "@bundle:com.example.simplecalculator/entry/ets/viewmodel/PressKeysItem";
export class PressKeysBeanViewModel {
    /**
     * Key array data.
     */
    getPressKeys(): Array<Array<PressKeysBean>> {
        return [
            [
                new PressKeysBean(0, '32vp', '32vp', 'clean', { "id": 50331680, "type": 20000, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" }),
                new PressKeysBean(1, '19vp', '43vp', '7'),
                new PressKeysBean(1, '19vp', '43vp', '8'),
                new PressKeysBean(1, '19vp', '43vp', '9'),
                new PressKeysBean(0, '32vp', '32vp', 'div', { "id": 50331682, "type": 20000, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" })
            ],
            [
                new PressKeysBean(0, '32vp', '32vp', 'mul', { "id": 50331685, "type": 20000, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" }),
                new PressKeysBean(1, '19vp', '43vp', '4'),
                new PressKeysBean(1, '19vp', '43vp', '5'),
                new PressKeysBean(1, '19vp', '43vp', '6'),
                new PressKeysBean(0, '32vp', '32vp', 'add', { "id": 50331679, "type": 20000, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" })
            ],
            [
                new PressKeysBean(0, '24vp', '24vp', 'min', { "id": 50331684, "type": 20000, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" }),
                new PressKeysBean(1, '19vp', '43vp', '1'),
                new PressKeysBean(1, '19vp', '43vp', '2'),
                new PressKeysBean(1, '19vp', '43vp', '3'),
                new PressKeysBean(0, '32vp', '32vp', 'equ', { "id": 50331683, "type": 20000, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" })
            ],
            [
                new PressKeysBean(1, '25vp', '43vp', '%'),
                new PressKeysBean(1, '19vp', '43vp', '0'),
                new PressKeysBean(1, '19vp', '43vp', '.'),
                new PressKeysBean(0, '30.48vp', '20vp', 'del', { "id": 50331681, "type": 20000, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" })
            ]
        ];
    }
    /**
     * Scientific keys array data.
     */
    getScientificKeys(): Array<Array<PressKeysBean>> {
        return [
            [
                new PressKeysBean(1, '16vp', '35vp', 'sin'),
                new PressKeysBean(1, '16vp', '35vp', 'cos'),
                new PressKeysBean(1, '16vp', '35vp', 'tan'),
                new PressKeysBean(1, '16vp', '35vp', 'log'),
                new PressKeysBean(1, '16vp', '35vp', 'ln')
            ],
            [
                new PressKeysBean(1, '16vp', '35vp', '√'),
                new PressKeysBean(1, '16vp', '35vp', '^'),
                new PressKeysBean(1, '16vp', '35vp', '!'),
                new PressKeysBean(1, '16vp', '35vp', 'π'),
                new PressKeysBean(1, '16vp', '35vp', 'e')
            ],
            [
                new PressKeysBean(1, '16vp', '35vp', '('),
                new PressKeysBean(1, '16vp', '35vp', ')'),
                new PressKeysBean(1, '16vp', '35vp', 'x²'),
                new PressKeysBean(1, '16vp', '35vp', '1/x'),
                new PressKeysBean(1, '16vp', '35vp', '方程')
            ],
            [
                new PressKeysBean(1, '16vp', '35vp', ','),
                new PressKeysBean(1, '16vp', '35vp', '-'),
                new PressKeysBean(1, '16vp', '35vp', ''),
                new PressKeysBean(1, '16vp', '35vp', ''),
                new PressKeysBean(1, '16vp', '35vp', '')
            ]
        ];
    }
}
let keysModel = new PressKeysBeanViewModel();
export default keysModel as PressKeysBeanViewModel;
