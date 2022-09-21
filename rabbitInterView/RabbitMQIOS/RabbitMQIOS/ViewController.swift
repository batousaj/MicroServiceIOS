//
//  ViewController.swift
//  RabbitMQIOS
//
//  Created by Mac Mini 2021_1 on 21/09/2022.
//

import UIKit
import RMQClient

class ViewController: UIViewController {

    var messageList = UITableView()
    var messageBox = UITextField()
    var buttonSend = UIButton()
    var message = [Message]()

    var id = ""
    var connection:RMQConnection!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.createNavigator()
        self.setupRMQConnection()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createMessageView()
        self.createChatBox()
    }

    func createNavigator() {
        self.title = "Server Queue"
        self.navigationController?.navigationBar.backgroundColor = .systemGray6
        let barButton = UIBarButtonItem.init(image: UIImage.init(systemName: "plus.circle.fill")!, style: .done, target: self, action: #selector(OnAddMessage))
        barButton.tintColor = .black

        self.navigationItem.rightBarButtonItem = barButton
    }

    func createChatBox() {
        self.view.addSubview(buttonSend)
        buttonSend.translatesAutoresizingMaskIntoConstraints = false
        buttonSend.clipsToBounds = true
        buttonSend.layer.cornerRadius = 20
        buttonSend.setBackgroundImage(UIImage.init(systemName: "paperplane.fill")!, for: .normal)
        buttonSend.tintColor = .black
        buttonSend.addTarget(self, action: #selector(OnClickSend), for: .touchUpInside)

        let contraints = [
            self.buttonSend.topAnchor.constraint(equalTo: self.messageList.bottomAnchor , constant: 10),
            self.buttonSend.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40),
            self.buttonSend.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.buttonSend.widthAnchor.constraint(equalToConstant: 50)
        ]

        NSLayoutConstraint.activate(contraints)

        self.view.addSubview(messageBox)
        messageBox.translatesAutoresizingMaskIntoConstraints = false
        messageBox.clipsToBounds = true
        messageBox.layer.cornerRadius = 20
        messageBox.textAlignment = .left
        messageBox.backgroundColor = .systemGray6

        let contraints1 = [
            self.messageBox.topAnchor.constraint(equalTo: self.messageList.bottomAnchor , constant: 10),
            self.messageBox.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40),
            self.messageBox.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.messageBox.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80)
        ]

        NSLayoutConstraint.activate(contraints1)

    }

    func createMessageView() {
        self.view.addSubview(messageList)
        messageList.translatesAutoresizingMaskIntoConstraints = false
        messageList.delegate = self
        messageList.dataSource = self
        messageList.register(MessageViewCell.self, forCellReuseIdentifier: "MessageCell")
        messageList.backgroundColor = .systemGray6
        messageList.transform = CGAffineTransform(rotationAngle: (-.pi))

        let contraints = [
            self.messageList.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor , constant: 20),
            self.messageList.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            self.messageList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.messageList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ]

        NSLayoutConstraint.activate(contraints)
    }

    func setupRMQConnection() {
        connection = RMQConnection(uri: "amqp://guest:guest@localhost:15672/",
                                   delegate: RMQConnectionDelegateLogger())
//        connection = RMQConnection(delegate: RMQConnectionDelegateLogger())
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
#if TEST
        return 2
#else
        return message.count
#endif
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageViewCell
        cell.transform = CGAffineTransform(rotationAngle: (-.pi))
        cell.name.text = self.message[indexPath.row].id
        cell.message.text = self.message[indexPath.row].message
        return cell
    }

}

extension ViewController {

    @objc func OnAddMessage() {
        self.id = "Thien"
        connection.start()
        let channel = connection.createChannel()
        let q = channel.queue("id: Thien")
        q.subscribe({ m in
            print("Received: \(String(describing: String(data: m.body, encoding: String.Encoding.utf8)))")
            self.message.append(Message(id: "T", message: String(data: m.body, encoding: String.Encoding.utf8)!))
        })
        self.messageList.reloadData()
    }

    @objc func OnClickSend() {
        connection.start()
        let channel = connection.createChannel()
        let q = channel.queue("id: Thien")

        if let data = self.messageBox.text?.data(using: String.Encoding.utf8) {
            channel.defaultExchange().publish(data ,routingKey: q.name)
//            let number = x.publish(data)
//            print("Send: \(number)")
//            message.append(Message(id: "T", message: self.messageBox.text!))
        } else {
            self.present(UIAlertController.alertWarning(message: "Can not send message"), animated: true)
        }

//        self.messageList.reloadData()
        connection.close()
    }

}

