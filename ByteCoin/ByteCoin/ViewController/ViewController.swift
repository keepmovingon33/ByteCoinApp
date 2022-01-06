//
//  ViewController.swift
//  ByteCoin
//
//  Created by sky on 1/5/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.getCoinPrice(for: coinManager.currencyArray[0])
    }


}

// MARK:- UIPickerView Datasource Methods

extension ViewController: UIPickerViewDataSource {
    
    // return how many columns that we want to have
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

// MARK:- UIPickerVIew Delegate Methods

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(coinManager.currencyArray[row])
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

extension ViewController: CoinManagerDelegate {
    func didUpdatePrice(rate: String, currency: String) {
        DispatchQueue.main.async { [weak self] in
            self?.bitcoinLabel.text = rate
            print(rate)
            self?.currencyLabel.text =  currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
