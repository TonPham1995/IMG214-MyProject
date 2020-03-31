

import UIKit

class YoutubeVideoViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    var videos:[Video] = []
    var video:Video = Video()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      let video = Video()
               video.Key = "2rIiuLXXGEg"
               video.Title = "Lucian: Champion Spotlight | Gameplay - League of Legends"
               videos.append(video)
               
               let video2 = Video()
               video2.Key = "KN3OYwP8nHE"
               video2.Title = "Jinx: Champion Spotlight | Gameplay - League of Legends"
               videos.append(video2)
               
               let video3 = Video()
               video3.Key = "gZDJqpFspmg"
               video3.Title = "Vayne: Champion Spotlight | Gameplay - League of Legends"
               videos.append(video3)
        
               let video4 = Video()
               video4.Key = "-2ieoD-uJxE"
               video4.Title = "Levi Montage The Styling Jungler (Best Of Levi) | League of Legends"
               videos.append(video4)
        
               let video5 = Video()
               video5.Key = "yMvqaad4tE4"
               video5.Title = "Best Of Levi - The Kha'Zix God | League Of Legends"
               videos.append(video5)
        
               let video6 = Video()
               video6.Key = "75DhwACHR0A"
               video6.Title = "Best Of SofM - Best Vietnamese Player | League of Legends"
               videos.append(video6)
        
               let video7 = Video()
               video7.Key = "YVEE-osceXs"
               video7.Title = "SofM Montage #2 | The Legendary Player Of Vietnam | League Of Legends"
               videos.append(video7)
        
               
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideoTableViewCell
        
        cell.videoTitle.text = videos[indexPath.row].Title
        let url = "https://img.youtube.com/vi/\(videos[indexPath.row].Key)/0.jpg"
        cell.videoImage.downloaded(from: url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vi = videos[indexPath.row]
        self.video = vi
        
        performSegue(withIdentifier: "toVideo", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toVideo" {
            
            let vc = segue.destination as! VideoViewController
            vc.video = self.video
            
        }
        
    }
    
}

class Video{
    var Key:String = ""
    var Title:String = ""
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
