//
//  ViewController.swift
//  UseMap1123
//
//  Created by 503-08 on 23/11/2018.
//  Copyright © 2018 leewoomi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBAction func moveDetail(_ sender: Any) {
        let detailTableViewController =
            self.storyboard?.instantiateViewController(withIdentifier: "DetailTableViewController") as! DetailTableViewController
        detailTableViewController.mapItems = self.matchingItems
        self.title = "MainView"
        
        self.navigationController?.pushViewController(detailTableViewController, animated: true)
        
    }

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    func performSearch(){
        //기존 검색 내용 삭제
        matchingItems.removeAll()
        //검색 객체 만들기
        let request = MKLocalSearch.Request()
        //검색어와 검색 영역 설정
        request.naturalLanguageQuery = searchText.text
        request.region = mapView.region
        //검색 요청 객체 생성
        let search = MKLocalSearch(request: request)
        //검색 요청과 핸들러
        search.start(completionHandler:{(response:MKLocalSearch.Response!, error:Error!) in
            if error != nil{
                print("검색 중 에러")
            }else if response?.mapItems.count == 0{
                print("검색된 결과가 없음")
            }else{
                print("검색 성공")
                //전체 데이터를 순회하면서
                for item in response.mapItems as [MKMapItem]{
                    //데이터를 한 개 씩 배열에 저장
                    self.matchingItems.append(item as MKMapItem)
                    //각각을 맵 에 출력
                    let annotation = MKPointAnnotation()
                    //어노테이션 정보 생성
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }


    @IBAction func search(_ sender: Any) {
        searchText.resignFirstResponder()
        mapView.removeAnnotations(mapView.annotations)
        self.performSearch()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

