
variable "region" {
  default     = "eu-west-2"
  description = "The aws region to deploy to"
}
variable "instance_count" {
  default     = 0
  description = "The amount of versions of the infrastructer to make "
}
variable "PlaygroundName" {
  default     = "nov-"
  description = "The playground name to tag all resouces with"
}
variable "WorkstationPassword" {
  default     = "playground"
  description = "The password of the workstation ssh"
}

variable "instances" {
  description = "number of instances per dns record"
}
variable "adjectives" {
  default = ["funny", "sweet", "proud", "suited", "loved", "firm", "settling", "premium", "feasible", "welcome", "pumped", "trusty", "rational", "moving", "fast", "social", "logical", "on", "driving", "perfect", "equal", "becoming", "still", "touched", "fair", "quiet", "ample", "master", "fun", "big", "full", "credible", "inspired", "pet", "willing", "guiding", "useful", "close", "smashing", "stunning", "musical", "evolved", "teaching", "artistic", "learning", "singular", "funky", "optimal", "loving", "measured", "whole", "verified", "finer", "glorious", "outgoing", "living", "refined", "valued", "champion", "integral", "topical", "humble", "valid", "patient", "accurate", "allowed", "tight", "uncommon", "ideal", "comic", "lasting", "concise", "certain", "vocal", "legible", "humane", "adapted", "romantic", "balanced", "model", "informed", "dashing", "smart", "select", "enhanced", "clean", "noble", "saving", "unbiased", "one", "cool", "humorous", "creative", "ace", "crack", "magical", "rare", "healthy", "key", "primary", "novel", "genuine", "allowing", "careful", "real", "flexible", "known", "above", "hot", "proven", "profound", "ruling", "supreme", "liberal", "super", "up", "sharp", "regular", "causal", "exciting", "deciding", "cosmic", "giving", "working", "better", "precious", "climbing", "cute", "beloved", "powerful", "blessed", "viable", "eternal", "included", "popular", "alert", "assuring", "eminent", "sensible", "prime", "choice", "star", "rapid", "quality", "lenient", "central", "simple", "awaited", "amazed", "brave", "stirring", "polished", "together", "tolerant", "first", "wanted", "coherent", "welcomed", "witty", "oriented", "splendid", "enabled", "precise", "nearby", "inviting", "communal", "dominant", "pure", "enough", "meet", "secure", "native", "vital", "probable", "adjusted", "mint", "pleasant", "gorgeous", "well", "relaxed", "darling", "actual", "definite", "main", "sacred", "rested", "immortal", "present", "smooth", "live", "internal", "evident", "major", "engaged", "optimum", "caring", "active", "flying", "trusting", "closing", "bursting", "arriving", "daring", "heroic", "great", "neutral", "united", "tender", "emerging", "able", "enormous", "literate", "divine", "stirred", "right", "free", "chief", "positive", "holy", "polite", "proper", "amazing", "huge", "clever", "sunny", "adequate", "grateful", "modern", "sure", "relaxing", "thankful", "handy", "absolute", "striking", "content", "cunning", "pro", "pleasing", "enabling", "poetic", "engaging", "casual", "picked", "decent", "renewed", "summary", "workable", "selected", "more", "busy", "safe", "settled", "excited", "unique", "possible", "ultimate", "joint", "fleet", "fit", "set", "concrete", "current", "eager", "natural", "fancy", "hopeful", "liked", "delicate", "factual", "glad", "civil", "expert", "adapting", "immense", "sharing", "composed", "smiling", "curious", "lucky", "hardy", "evolving", "tidy", "talented", "dear", "flowing", "wired", "intense", "guided", "classic", "glowing", "true", "wise", "obliging", "fresh", "relevant", "special", "alive", "new", "driven", "maximum", "solid", "unified", "sweeping", "nice", "prompt", "bright", "immune", "tough", "in", "crisp", "ready", "frank", "prepared", "crucial", "fitting", "apt", "strong", "tops", "knowing", "sterling", "exact", "legal", "accepted", "mutual", "wealthy", "pleased", "elegant", "rich", "intent", "diverse", "modest", "clear", "generous", "usable", "cuddly", "bold", "easy", "noted", "keen", "thorough", "amusing", "happy", "relative", "resolved", "quick", "fine", "moved", "cheerful", "peaceful", "honest", "good", "amused", "golden", "normal", "advanced", "helping", "innocent", "square", "large", "relieved", "neat", "awake", "brief", "direct", "trusted", "upward", "moral", "sought", "pretty", "helped", "light", "hip", "correct", "renewing", "related", "wondrous", "desired", "aware", "intimate", "mature", "faithful", "enjoyed", "notable", "charming", "just", "epic", "loyal", "suitable", "harmless", "top", "ethical", "famous", "game", "dynamic", "organic", "distinct", "fond", "grand", "stable", "open", "capital", "steady", "next", "devoted", "warm", "upright", "infinite", "electric", "needed", "sound", "capable", "boss", "superb", "subtle", "magnetic", "massive", "saved", "fluent", "gentle", "endless", "growing", "leading", "apparent", "discrete", "promoted", "exotic", "robust", "charmed", "vast", "complete", "improved", "kind", "winning", "skilled", "calm", "deep", "grown", "touching", "sincere", "national", "shining", "merry", "helpful", "mighty", "many", "worthy", "destined", "equipped", "assured"]
}

// PLEASE TAKE CARE WHEN EDITING THIS DUE TO COSTS. 

variable "deploy_count" {
  description = "Change this for the number of users of the playground"
  default     = 2
}
variable "InstanceRole" {
  default     = false
  description = "The Role of the instance to take"
}
