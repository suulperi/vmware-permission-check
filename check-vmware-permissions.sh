#!/bin/bash
#Original by Oscar Lindholm olindhol@redhat.com
#Modified Tommi Sohlberg

# Script for verifying adequate role permission for VMware service account used for OpenShift IPI installation

# Pre-requirements
# GOVC - CLI for VMware.
# Credentials for the Service Account

# Required permissions for IPI Installer
reqPermissions=("Cns.Searchable" "InventoryService.Tagging.AttachTag" "InventoryService.Tagging.CreateCategory" "InventoryService.Tagging.CreateTag" "InventoryService.Tagging.DeleteCategory" "InventoryService.Tagging.DeleteTag" "InventoryService.Tagging.EditCategory" "InventoryService.Tagging.EditTag" "Sessions.ValidateSession" "StorageProfile.Update" "StorageProfile.View" "Host.Config.Storage" "Resource.AssignVMToPool" "VApp.AssignResourcePool" "VApp.Import" "VirtualMachine.Config.AddNewDisk" "Datastore.AllocateSpace" "Datastore.Browse" "Datastore.FileManagement" "InventoryService.Tagging.ObjectAttachable" "Network.Assign" "Resource.AssignVMToPool" "VApp.Import" "VirtualMachine.Config.AddExistingDisk" "VirtualMachine.Config.AddNewDisk" "VirtualMachine.Config.AddRemoveDevice" "VirtualMachine.Config.AdvancedConfig" "VirtualMachine.Config.Annotation" "VirtualMachine.Config.CPUCount" "VirtualMachine.Config.DiskExtend" "VirtualMachine.Config.DiskLease" "VirtualMachine.Config.EditDevice" "VirtualMachine.Config.Memory" "VirtualMachine.Config.RemoveDisk" "VirtualMachine.Config.Rename" "VirtualMachine.Config.ResetGuestInfo" "VirtualMachine.Config.Resource" "VirtualMachine.Config.Settings" "VirtualMachine.Config.UpgradeVirtualHardware" "VirtualMachine.Interact.GuestControl" "VirtualMachine.Interact.PowerOff" "VirtualMachine.Interact.PowerOn" "VirtualMachine.Interact.Reset" "VirtualMachine.Inventory.Create" "VirtualMachine.Inventory.CreateFromExisting" "VirtualMachine.Inventory.Delete" "VirtualMachine.Provisioning.Clone" "VirtualMachine.Provisioning.MarkAsTemplate" "VirtualMachine.Provisioning.DeployTemplate" "Resource.AssignVMToPool" "VApp.Import" "VirtualMachine.Config.AddExistingDisk" "VirtualMachine.Config.AddNewDisk" "VirtualMachine.Config.AddRemoveDevice" "VirtualMachine.Config.AdvancedConfig" "VirtualMachine.Config.Annotation" "VirtualMachine.Config.CPUCount" "VirtualMachine.Config.DiskExtend" "VirtualMachine.Config.DiskLease" "VirtualMachine.Config.EditDevice" "VirtualMachine.Config.Memory" "VirtualMachine.Config.RemoveDisk" "VirtualMachine.Config.Rename" "VirtualMachine.Config.ResetGuestInfo" "VirtualMachine.Config.Resource" "VirtualMachine.Config.Settings" "VirtualMachine.Config.UpgradeVirtualHardware" "VirtualMachine.Interact.GuestControl" "VirtualMachine.Interact.PowerOff" "VirtualMachine.Interact.PowerOn" "VirtualMachine.Interact.Reset" "VirtualMachine.Inventory.Create" "VirtualMachine.Inventory.CreateFromExisting" "VirtualMachine.Inventory.Delete" "VirtualMachine.Provisioning.Clone" "VirtualMachine.Provisioning.DeployTemplate" "VirtualMachine.Provisioning.MarkAsTemplate" "Folder.Create" "Folder.Delete" "System.Anonymous" "System.Read" "System.View")

# Main function
function main() {
case $1 in 

        -s) permissionCheck
        ;;
        -h) helpmsg
        ;;
        *) helpmsg
        ;;
esac
}

function helpmsg() {
echo "Usage: $0 [options]"
echo
echo "Options:"
echo "    -s          Checks if user got adequate permissions."
echo "    -h          Prints this messages and exits."

exit
}

function permissionCheck() {
govc about > /dev/null 2>&1

if [ $? != 0 ]; then
  echo "GOVC was not found or you are not logged in. Please check your path or log in."
  exit 1
fi

results=$(
  for role in $(govc permissions.ls | awk '(NR>1)' | awk '{ print $1 '} | sort | uniq -u); do 
    govc role.ls $role 2>/dev/null; 
  done
)

for item in ${reqPermissions[@]}; do
  if ( IFS=$'\n'; echo "${results[*]}" ) | grep -qFx "$item"; then
      echo -e "$item \xE2\x9C\x94"
  else
      echo -e "$item \xE2\x9D\x8C"
  fi
done
}

main $1
