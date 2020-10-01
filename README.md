# Yet Another Backup Script

A simple mini-utility, a small Ruby script that compresses local `~/Dropbox/dotFiles` directory and uploads the archive to Yandex.Disk.

Nothing fancy.

Usage:

```bash
$ env ACCESS_TOKEN=AgAA...Isar8 ruby runner.rb
```

To get Yandex.Disk access token, check [this page](https://yandex.com/dev/disk/api/concepts/quickstart.html/).

## TODO

- [ ] Check number of backups, and leave only a few latest
