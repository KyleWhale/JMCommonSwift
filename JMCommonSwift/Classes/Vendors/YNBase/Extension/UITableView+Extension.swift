//
//  UITableView+Extension.swift
//  YNBase
//
//  Created by guo hongquan on 2021/6/15.
//

import UIKit
//import MJRefresh
//
//
//public enum RefreshStatus {
//    case none
//    case beingHeaderRefresh
//    case endHeaderRefresh
//    case beingFooterRefresh
//    case endFooterRefresh
//    case noMoreData
//}
//
//public extension UITableView {
//
//    public func yn_headerRefresh(target: Any, selector: Selector) {
//        let header = MJRefreshNormalHeader(refreshingTarget: target, refreshingAction: selector)
//        header.setTitle("数据加载中...", for: .refreshing)
//        header.setTitle("松开刷新数据", for: .pulling)
//        self.mj_header = header
//    }
//
//    public func yn_headerRefresh(_ block: @escaping () -> ()) {
//        let header = MJRefreshNormalHeader(refreshingBlock: block)
//        header.setTitle("数据加载中...", for: .refreshing)
//        header.setTitle("松开刷新数据", for: .pulling)
//        self.mj_header = header
//    }
//
//    public func yn_footerRefresh(target: Any, selector: Selector) {
//        let footer = MJRefreshAutoNormalFooter.init(refreshingTarget: target,
//        refreshingAction: selector)
//        footer.isHidden = true
//        footer.setTitle("已经到底啦", for: .noMoreData)
//        footer.setTitle("上拉加载更多", for: .idle)
//        self.mj_footer = footer
//    }
//
//    public func yn_footerRefresh(_ block: @escaping () -> ()) {
//        let footer = MJRefreshAutoNormalFooter(refreshingBlock: block)
//        footer.isHidden = true
//        footer.setTitle("已经到底啦", for: .noMoreData)
//        footer.setTitle("上拉加载更多", for: .idle)
//        self.mj_footer = footer
//    }
//
//    public func yn_endHeaderRefresh() {
//        self.mj_header?.endRefreshing()
//    }
//
//    public func yn_endFooterRefresh(_ noMore: Bool = false) {
//        if noMore {
//            self.mj_footer?.endRefreshingWithNoMoreData()
//        } else {
//            self.mj_footer?.endRefreshing()
//        }
//    }
//
//}
public extension UITableView {
    func yn_radiusTableViewSection(radius: CGFloat = 10, indexPath:IndexPath, cell: UITableViewCell) {
        
        //下面为设置圆角操作（通过遮罩实现）
        let sectionCount = self.numberOfRows(inSection: indexPath.section)
        let shapeLayer = CAShapeLayer()
        cell.layer.mask = nil
        //当前分区有多行数据时
        if sectionCount > 1 {
            switch indexPath.row {
            //如果是第一行,左上、右上角为圆角
            case 0:
                var bounds = cell.bounds
                bounds.origin.y += 1.0  //这样每一组首行顶部分割线不显示
                let bezierPath = UIBezierPath(roundedRect: bounds,
                                              byRoundingCorners: [.topLeft,.topRight],
                                              cornerRadii: CGSize(width: radius,height: radius))
                shapeLayer.path = bezierPath.cgPath
                cell.layer.mask = shapeLayer
            //如果是最后一行,左下、右下角为圆角
            case sectionCount - 1:
                var bounds = cell.bounds
                bounds.size.height -= 1.0  //这样每一组尾行底部分割线不显示
                let bezierPath = UIBezierPath(roundedRect: bounds,
                                              byRoundingCorners: [.bottomLeft,.bottomRight],
                                              cornerRadii: CGSize(width: radius,height: radius))
                shapeLayer.path = bezierPath.cgPath
                cell.layer.mask = shapeLayer
            default:
                break
            }
        }
        //当前分区只有一行行数据时
        else {
            //四个角都为圆角（同样设置偏移隐藏首、尾分隔线）
            let bezierPath = UIBezierPath(roundedRect:
                                            cell.bounds,
                                          cornerRadius: radius)
            shapeLayer.path = bezierPath.cgPath
            cell.layer.mask = shapeLayer
        }
    }
}
