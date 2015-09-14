class env ($given_variant){
  ## Global variables used for this build
  # build to be run inside g5k (could become a parameter)
  $target_g5k = true
  # build from inside g5k (proxy parameter may be set before running any action or network will be unavailable)
  $from_g5k = false

  ## Variant (min/base/nfs/prod/big/xen)
  # need to create a local variable to access it from any sub-recipe.
  $variant = $given_variant
  $version = file('env/version')

  ## Define a stage that will be runned after most of normal installation
  # As an exemple, this is used to setup apt-proxy. If setup earlier, any package installation would fail (proxy unreachable)
  stage { 'g5k_adjustment' :
    require => Stage['main'];
  }

  ## Call the actual recipe
  case $variant {
    'min' :  { include env::min }
    'base':  { include env::base }
    'nfs' :  { include env::nfs }
    'prod':  { include env::prod }
    'big' :  { include env::big }
    'xen' :  { include env::xen }
    default: { notify {"variant $variant is not implemented":}}
  }
}
