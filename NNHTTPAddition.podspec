Pod::Spec.new do |s|
  s.name         = "NNHTTPAddition"
  s.version      = "0.0.1"
  s.summary      = "Easy create NSURLRequest for HTTP method GET PUT DELETE POST(Multipart)"
  s.homepage     = "https://github.com/naonya3/NSMutableURLRequest-NNHTTPAddition"
  s.license      = 'MIT'
  s.author       = { "Naoto Horiguchi" => "naoto.horiguchi@gmail.com" }
  s.platform     = :ios, '4.3'
  s.source       = { :git => "https://github.com/naonya3/NSMutableURLRequest-NNHTTPAddition.git", :tag => "0.0.1" }
  s.source_files  = 'NNHTTPAddition', 'NNHTTPAddition/*.{h,m}'
end
