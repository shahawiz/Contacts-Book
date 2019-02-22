########### Contact Book Script ############
#App Functions
#Validation To Add Contacts
function MobValidation () {
    if [[ $1 =~ ^0[10|11|12|15]([0-9]{9})$ ]]; then return 1 ; fi
    
}
#Searching
function search_by_name(){
    echo -e "search by name : \c"
    read nam2
    awk -F: -v name="$nam2" 'BEGIN {flag = 0} {if ($1==name) {print NR "- ""name: "$1 "  ""email: "$2 "   ""phone: "$3;flag=1;}} END{if(flag==0)print"not found"}' database
}

function search_by_email(){
    echo -e "search by mail : \c"
    read mail1
    awk -F: -v mail="$mail1" 'BEGIN {flag = 0} {if ($2==mail){ print NR "- ""name: "$1 "  ""email: "$2 "   ""phone: "$3;flag=1;}} END{if(flag==0)print"not found"}' database
}

function search_by_mobile(){
    echo -e "search by phone : \c"
    read phone1
    awk -F: -v phone="$phone1" 'BEGIN {flag = 0} {if ($3==phone) {print NR "- ""name: "$1 "  ""email: "$2 "   ""phone: "$3;flag=1;}} END{if(flag==0)print"not found"}' database
}

#ADD To Contacts
function Add (){
    echo -e "Enter Name : \c"
    read Name
    
    echo -e "Enter E-mail : \c"
    read Email
    
    while [ true ]; do
        echo -e "Enter Mobile number : \c"
        read Mob
        #Validate the Mobile
        MobValidation $Mob
        if [ $? == 1 ]; then
            #Add To Database
            echo $Name:$Mob:$Email >> database
            #back to menu
            StartMenu
            break
        fi
    done
    
}

function Remove () {
    sed -i "/^$1/d" database
}

function Edit(){
    #Get Contact name to make Edit
    echo "########## Edit Mode ##########"
    echo -e "Enter Name of Contact : \c"
    read Search_Name
    EditLine=$(awk -F: -v name="$Search_Name" '{if($1 == name) print $0}' database)
    #Passed Line
    Pa_Name=$(echo "$EditLine" | cut -d ":" -f 1)
    Pa_Mob=$(echo "$EditLine" | cut -d ":" -f 2)
    Pa_Email=$(echo "$EditLine" | cut -d ":" -f 3)
    
    PS3='What info you want to edit ? : '
    options=("Name" "Mobile" "Email" "Back")
    select opt in "${options[@]}"
    do
        case $opt in
            "Name")
                read -p "Enter the new name : " Pa_Name
                break
            ;;
            "Mobile")
                read -p "Enter the new Mobile : " Pa_Mob
                break
            ;;
            "Email")
                read -p "Enter the new Email : " Pa_Email
                break
            ;;
            "Back")
                break
            ;;
            *) echo invalid option;;
        esac
    done
    
    #Save the new Data
    echo $Pa_Name:$Pa_Mob:$Pa_Email >> database
    #Delete the old Data
    Remove $EditLine
    
    
}

function Search_Menu()
{
    PS3='Choose Search Mode ? : '
    options=("✎  Search by Name" "☎  Search by Mobile" "✉  Search by E-Mail" "⇠  Back to Menu")
    select opt in "${options[@]}"
    do
        case $opt in
            "✎  Search by Name")
                search_by_name
                break
            ;;
            "☎  Search by Mobile")
                search_by_mobile
                break
            ;;
            "✉  Search by E-Mail")
                search_by_email
                break
            ;;
            "⇠  Back to Menu")
                StartMenu
                break
            ;;
            *) echo Invalid selection;;
        esac
    done
}

function StartMenu()
{
    #Start Menu
    clear
    echo "_______________________________________________________________"
    echo "▒█▀▀█ █▀▀█ █▀▀▄ ▀▀█▀▀ █▀▀█ █▀▀ ▀▀█▀▀ █▀▀ 　 ▒█▀▀█ █▀▀█ █▀▀█ █░█"
    echo "▒█░░░ █░░█ █░░█ ░░█░░ █▄▄█ █░░ ░░█░░ ▀▀█ 　 ▒█▀▀▄ █░░█ █░░█ █▀▄"
    echo "▒█▄▄█ ▀▀▀▀ ▀░░▀ ░░▀░░ ▀░░▀ ▀▀▀ ░░▀░░ ▀▀▀ 　 ▒█▄▄█ ▀▀▀▀ ▀▀▀▀ ▀░▀"
    echo "_______________________________________________________________"
    
    PS3='Please enter your choice: '
    options=("✚  Add Contact" "✎  Edit Contact" "✘  Remove Contact" "➲  Search" "☹  Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "✚  Add Contact")
                Add
                break
            ;;
            "✎  Edit Contact")
                Edit
                break
            ;;
            "✘  Remove Contact")
                read -p "Enter Contact name to remove : " CName
                Remove $CName
                echo $CName "Deleted Successfully"
                StartMenu
                break
            ;;
            "➲  Search")
                Search_Menu
                break
            ;;
            "☹  Quit")
                break
            ;;
            *) echo invalid option;;
        esac
    done
    
}

#start App Menu
StartMenu



