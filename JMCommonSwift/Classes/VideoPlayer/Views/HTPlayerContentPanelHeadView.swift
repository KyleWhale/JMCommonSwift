//
//  HTPlayerContentPanelHeadView.swift
//  Cartoon
//
//  Created by James on 2023/5/5.
//

import SnapKit
import UIKit

class HTPlayerContentPanelHeadView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white.withAlphaComponent(0.6)
        view.adjustsFontSizeToFitWidth = true
        return view
    }()

    var title: String? {
        didSet {
            guard title != oldValue else { return }
            titleLabel.text = title
        }
    }
}

private extension HTPlayerContentPanelHeadView {
    func initUI() {
        addSubview(titleLabel)
    }

    func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
        }
    }
}
