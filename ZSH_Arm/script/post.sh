
# If more directories need executable perms, add them here
EXEDIRS="bin xbin vendor/bin"

set_perms() {
   if [ -z "$1" ] || [ -z "$2" ]; then
      return 1
   fi
   for file in $(list_zip_contents $1); do
      case "$file" in
         */su.d/*|*init*/*) ch=700; ;;
         */*bin*/*) ch=755; ;;
         *) ch=644; ;;
      esac
      $bb chmod $ch "${MODPATH}/${file}" >&2
   done
}


# Keep this named post_install as it will be called by the parent script
post_install() {
   # set perms right
   for dir in $EXEDIRS; do
      set_perms system/${dir} 755
   done
}
