if [ -f ~/rom/out/target/product/RMX2185/*UNOFFICIAL*.zip ]; then
      curl -s https://api.telegram.org/$tokentl/sendMessage -d chat_id=$idtl -d text="📤 Uploading Build $(cd ~/rom/out/target/product/RMX2185/ && ls *UNOFFICIAL*.zip)"
      rclone copy ~/rom/out/target/product/RMX2185/*UNOFFICIAL*.zip zona: -P

      cd ~/rom
      mkdir -p ~/.config

      mv romxx/configs/*telegram* ~/.config

      telegram-upload ~/rom/out/target/product/RMX2185/*UNOFFICIAL*.zip --to $idtl
      curl -s https://api.telegram.org/$tokentl/sendMessage -d chat_id=$idtl -d text="✅ Build $(cd ~/rom/out/target/product/RMX2185/ && ls *UNOFFICIAL*.zip) Uploaded Successfully!"
fi


