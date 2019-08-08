set -x
# If more directories need executable perms, add them here

set_perms() {
   for file in $(list_zip_contents $1); do
      if [ -d "${MODPATH}/$file" ]; then
         ch=755
      else
         case "$file" in
            */su.d/*|*init.d*/*) ch=700; ;;
            */*bin*/*) ch=755; ;;
            *) ch=644; ;;
         esac
      fi
      chmod $ch "${MODPATH}/${file}" >&2
   done
}


# Keep this named post_install as it will be called by the parent script
post_install() {
   set_perms system
}
set +x
