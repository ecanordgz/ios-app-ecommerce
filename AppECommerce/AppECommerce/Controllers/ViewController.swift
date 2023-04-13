//
//  ViewController.swift
//  AppECommerce
//
//  Created by Enrique Cano on 13/04/23.
//

import UIKit

class ViewController: UIViewController {

    var productos: [ItemsModel] = []
    
    @IBOutlet weak var buscarTextField: UITextField!
    @IBOutlet weak var productosTableView: UITableView!
    @IBOutlet weak var productosLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "eCommerce"
        
        productosTableView.delegate = self
        productosTableView.dataSource = self
        
        productosLoading.startAnimating()
        productosLoading.hidesWhenStopped = false
        buscarProductos(nombreProducto: "")
    }
    
    func buscarProductos(nombreProducto: String) {
        var urlString = "https://00672285.us-south.apigw.appdomain.cloud/demo-gapsi/search?&query=computer&page=1"
        if !nombreProducto.isEmpty {
            urlString = "https://00672285.us-south.apigw.appdomain.cloud/demo-gapsi/search?&query=\(nombreProducto)&page=1"
        }
        
        let urlSession = URLSession.shared
        
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("adb8204d-d574-4394-8c1a-53226a40876e", forHTTPHeaderField: "X-IBM-Client-Id")
            
            urlSession.dataTask(with: urlRequest) { data, response, error in
                if let dataResponse = data {
                    print(dataResponse)
                    let decodificador = JSONDecoder()
                    if let datosDecodificados = try? decodificador.decode(ItemModel.self, from: dataResponse) {
                        //print(datosDecodificados.item.props.pageProps.initialData.searchResult.itemStacks[0].items![0].name)
                        self.productos = datosDecodificados.item.props.pageProps.initialData.searchResult.itemStacks[0].items!
                        DispatchQueue.main.async {
                            self.productosTableView.reloadData()
                            self.productosLoading.stopAnimating()
                            self.productosLoading.hidesWhenStopped = true
                        }
                    }
                }
            }.resume()
        }
    }
    
    @IBAction func buscarButtonTouch(_ sender: UIButton) {
        productosLoading.startAnimating()
        productosLoading.hidesWhenStopped = false
        self.buscarProductos(nombreProducto: self.buscarTextField.text ?? "")
        view.endEditing(true)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celdaProducto = productosTableView.dequeueReusableCell(withIdentifier: "celdaProducto", for: indexPath) as! ProductTableViewCell
        DispatchQueue.global().async { [weak self] in
            if let imageString = self!.productos[indexPath.row].image {
                if let url = URL(string: imageString) {
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                celdaProducto.productImageView.image = image
                            }
                        }
                    }
                }
            }
        }
        
        celdaProducto.productTitle.text = self.productos[indexPath.row].name ?? "Sin descripcion disponible."
        if let price = self.productos[indexPath.row].price {
            celdaProducto.productPrice.text = "$ " + price.description
        } else {
            celdaProducto.productPrice.text = "$ 0"
        }
        
        return celdaProducto
    }
}

