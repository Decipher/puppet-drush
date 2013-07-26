class drush::git::drush (
  $git_branch = '',
  $git_tag    = '',
  $git_repo   = 'http://git.drupal.org/project/drush.git',
  $update     = false,
  ) {

  drush::git { $git_repo :
    path       => '/usr/share/php/',
    git_branch => $git_branch,
    git_tag    => $git_tag,
    update     => $update,
  }

  file {'symlink drush':
    ensure  => link,
    path    => '/usr/bin/drush',
    target  => '/usr/share/php/drush/drush.sh',
    require => Drush::Git[$git_repo],
    notify  => Exec['first drush run'],
  }

  # Needed to download a Pear library
  exec {'first drush run':
    command     => '/usr/bin/drush status',
    refreshonly => true,
    require     => File['symlink drush'],
  }

}
