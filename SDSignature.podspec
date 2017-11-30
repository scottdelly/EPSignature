
Pod::Spec.new do |s|
  s.name             = "SDSignature"
  s.version          = "2.0.0"
  s.summary          = "Signature component for iOS in Swift"
  s.description      = <<-DESC
Features
1. User can draw the signature either by finger or by apple pencil
2. Ability to save the signature as default signature
3. Ability to load the saved signature
4. Works on both orientations(portrait and landscape)
5. Works on both iPhone and iPad
6. Also can be embedded in any container view
7. Can extract the signature as Image
8. Draws smoothly
DESC
  s.homepage         = "https://github.com/scottdelly/SDSignature"
  s.license          = 'MIT'
  s.author           = { "scottdelly" => "scott@scottdelly.com" }
  s.source           = { :git => "https://github.com/scottdelly/SDSignature.git", :tag => s.version.to_s }

  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.source_files = 'Sources/**/*'
  s.resources        = ["Sources/EPSignatureViewController.xib"]
end
