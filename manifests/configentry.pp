# dovecot::configentry
# ===========================
#
# @summary manages a single dovecot config entry
#
# @note This class is only for internal use, use dovecot::config instead.
#
# @param file     the file to put the entry in
# @param key      the entry's key, or !include/!include_try
# @param sections the entry's sections as an array
# @param value    the entry's value
# @param comment  an optional comment to be printed above the entry
# @param ensure   whether the entry should be `present` or `absent`
#
# @see dovecot::config
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define dovecot::configentry (
  Stdlib::Absolutepath $file,
  String $key,
  $value,
  Optional[String] $comment = undef,
  Enum['present', 'absent'] $ensure = 'present',
  Array[String] $sections = [],
) {
  ensure_resource('dovecot::configfile', $file)

  $rsections = ['/'] + $sections
  $depth = length($sections)
  if ($depth > 0) {
    Integer[1,$depth].each |$i| {
      $section = join($rsections[0,$i+1], ' 03 ')
      $indent = sprintf("%${($i-1)*2}s", '')

      $section_name = $sections[$i-1]

      ensure_resource('concat::fragment', "dovecot ${file} config ${section} 01 section start", {
        target => $file,
        content => "${indent}${section_name} {\n",
      })
      ensure_resource('concat::fragment', "dovecot ${file} config ${section} 05 section end", {
        target => $file,
        content => "${indent}}\n",
      })
    }
  }

  # now for the value itself
  $indent = sprintf("%${$depth*2}s", '')
  $section = join($rsections, ' 03 ')

  if ($comment) {
    concat::fragment { "dovecot ${file} config ${section} 02 ${key} 01 comment":
      target  => $file,
      content => join(suffix(prefix(split($comment, '\n'), "${indent}# "), "\n")),
    }
  }

  case $key {
    '!include', '!include_try': {
      concat::fragment { "dovecot ${file} config ${section} 04 ${key} ${value}":
        target  => $file,
        content => "${key} ${value}\n",
      }
    }
    /\A!/: {
        fail("Key must not start with an exclamation mark: ${key}")
    }
    default: {
      $printed_value = dovecot::print_config_value($value)
      concat::fragment { "dovecot ${file} config ${section} 02 ${key} 02":
        target  => $file,
        content => "${indent}${key} = ${printed_value}\n",
      }
    }
  }
}

