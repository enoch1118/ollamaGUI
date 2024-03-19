//
//  USearchUtil.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/10/24.
//

import Foundation
import USearch

class USearchUtil {
    var usearch: USearchIndex!
    var vector: [[Float32]]!
    var document: [Document]!

    func buildIndex(_ vector: [[Float32]], document: [Document]) {
        self.vector = vector
        self.document = document
        usearch = USearchIndex.make(
            metric: .cos,
            dimensions: UInt32(vector.first!.count),
            connectivity: 16,
            quantization: .F32
        )
        usearch.reserve(1000)
        for i in 0 ..< vector.count {
            usearch.add(key: UInt64(i), vector: vector[i])
        }
    }

    func searchIndex(_ vector: [Float]) -> [Document] {
        let search = usearch.search(vector: vector, count: 4)
        return search.0.map { document[Int($0)] }
    }

    func saveVector(name: String) {
        let path = makeDirectory(name: name)
        do {
            try JSONEncoder().encode(document).write(to: URL(filePath:path.1))
        }catch {
            print("\(error)")
        }
        usearch.save(path: path.0)
    }

    func loadVector(name: String,dimensions: Int) -> Bool {
        usearch = USearchIndex.make(metric: .cos, dimensions: UInt32(dimensions), connectivity: 16, quantization: .F32)
        let home = FileManager.default.homeDirectoryForCurrentUser
        let dir = home.appendingPathComponent(".Muse", isDirectory: true)
            .appendingPathComponent("vectors", isDirectory: true)
        let file = dir.appendingPathComponent("\(name).vc")
        let docFile = dir.appendingPathComponent("\(name).dc")
        if !FileManager.default.fileExists(atPath: file.path) || !FileManager.default.fileExists(atPath: docFile.path) {
            print("no file exist")
            return false
        }
        usearch.load(path: file.path)
        do{
            let data = try String(contentsOf: docFile,encoding: .utf8).data(using: .utf8)
            self.document = try JSONDecoder().decode([Document].self,from: data!)
            
        }catch{
            print("\(error)")
            return false
        }
        return true
    }

    func makeDirectory(name: String) -> (String,String) {
        let home = FileManager.default.homeDirectoryForCurrentUser
        let museRoot = home.appendingPathComponent(".Muse", isDirectory: true)
        checkPathIfNotExisetThenCreate(museRoot)
        let dir = museRoot.appendingPathComponent("vectors", isDirectory: true)
        checkPathIfNotExisetThenCreate(dir)
        let file = dir.appendingPathComponent("\(name).vc")
        let docFile = dir.appendingPathComponent("\(name).dc")

        if !FileManager.default.fileExists(atPath: file.path) {
            FileManager.default.createFile(atPath: file.path, contents: nil)
        }
        
        if !FileManager.default.fileExists(atPath: docFile.path){
            FileManager.default.createFile(atPath: docFile.path, contents: nil)
        }
        

        return (file.path,docFile.path)
    }

    func checkPathIfNotExisetThenCreate(_ path: URL) {
        if !FileManager.default.fileExists(atPath: path.path) {
            try? FileManager.default.createDirectory(
                at: path,
                withIntermediateDirectories: true
            )
        }
    }
}
