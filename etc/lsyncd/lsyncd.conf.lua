settings {
    logfile = "/var/log/lsyncd.log",
    statusFile = "/var/log/lsyncd.stat",
    statusInterval = 5,
    insist = true,
    nodaemon = false,
}

local repo_base = "/home/alex/configs"

-- Список папок для синхронизации
local paths = {
    "/etc/skel",
    "/etc/lsyncd",
    "/boot/efi/loader/entries",
}

-- Список файлов для синхронизации
local files = {
    "/etc/default/useradd",
    "/boot/efi/loader/loader.conf",
}

--для .zshrc и nvim
sync {                      -- .zshrc
    default.rsync,
    source = "/home/alex",  -- Добавляем слэш для указания директории
    target = repo_base .. "/root/",
    rsync = {
        archive = true,
        _extra = {
            "--include=.zshrc",
            "--exclude=*",
        }
    }
}
sync {                      -- nvim
    default.rsync,
    source = "/home/alex/.config/nvim",  -- Добавляем слэш для указания директории
    target = repo_base .. "/root/.config/nvim",
    rsync = {
        archive = true,
    }
}

-- Синхронизация папок
for _, src_path in ipairs(paths) do
    sync {
        default.rsync,
        source = src_path,
        target = repo_base .. src_path,
        rsync = {
            archive = true,
        }
    }
end

-- Синхронизация файлов
for _, file_path in ipairs(files) do
    local dir_path = file_path:match("^(.*)/[^/]*$") or "/"
    local filename = file_path:match("/([^/]*)$") or file_path

    sync {
        default.rsync,
        source = dir_path .. "/",  -- Добавляем слэш для указания директории
        target = repo_base .. dir_path .. "/",
        rsync = {
            archive = true,
            _extra = {
                "--include=" .. filename,
                "--exclude=*",
            }
        }
    }
end
