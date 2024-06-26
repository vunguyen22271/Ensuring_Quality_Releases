# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
# from selenium.webdriver.support.relative_locator import with_tag_name

from datetime import datetime

login_url = 'https://www.saucedemo.com/'
inventory_url = 'https://www.saucedemo.com/inventory.html'
cart_url = 'https://www.saucedemo.com/cart.html'

def print_with_timestamp(message):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{timestamp}] {message}")

def create_driver():
    print_with_timestamp ('Starting the browser...')
    options = ChromeOptions()
    options.add_argument("--headless")
    return webdriver.Chrome(options=options)

# Start the browser and login with standard_user
def login (driver, user, password):
    print_with_timestamp ('Starting the browser...')
    # --uncomment when running in Azure DevOps.
    # options = ChromeOptions()
    # options.add_argument("--headless") 
    # driver = webdriver.Chrome(options=options)
    # driver = webdriver.Chrome()
    print_with_timestamp ('Browser started successfully. Navigating to the demo page to login.')
    driver.get('https://www.saucedemo.com/')
    driver.find_element(By.CSS_SELECTOR, "input[id='user-name']").send_keys(user)
    driver.find_element(By.CSS_SELECTOR, "input[id='password']").send_keys(password)
    driver.find_element(By.CSS_SELECTOR, "input[id='login-button']").click()
    print_with_timestamp('Login successful.')

def add_items_to_cart(driver):
    items_in_cart = []
    print_with_timestamp ('Test: adding items to cart')
    elements = driver.find_elements(By.CLASS_NAME, 'inventory_item')
    for item in elements:
        item_name = item.find_element(By.CLASS_NAME, 'inventory_item_name').text
        items_in_cart.append(item_name)
        item.find_element(By.CLASS_NAME, 'btn_inventory').click()
        print_with_timestamp('Added {} to cart'.format(item_name))
    cart_element = driver.find_element(By.CLASS_NAME, 'shopping_cart_badge')
    assert int(cart_element.text) == len(elements)
    driver.find_element(By.CLASS_NAME, 'shopping_cart_link').click()
    assert cart_url in driver.current_url
    for item in driver.find_elements(By.CLASS_NAME, 'inventory_item_name'):
        assert item.text in items_in_cart
    print_with_timestamp ('Test Add Items in cart Success.')

def remove_items_from_cart(driver):
    print_with_timestamp ('Test: removing items from cart')
    driver.find_element(By.CLASS_NAME, 'shopping_cart_link').click()
    assert cart_url in driver.current_url

    print_with_timestamp("Items in Cart: {}".format(len(driver.find_elements(By.CLASS_NAME, 'cart_item'))))
    
    for item in driver.find_elements(By.CLASS_NAME, 'cart_item'):
        item_name = item.find_element(By.CLASS_NAME, 'inventory_item_name').text
        item.find_element(By.CLASS_NAME, 'cart_button').click()
        print_with_timestamp('Removed {} from cart'.format(item_name))

    assert len(driver.find_elements(By.CLASS_NAME, 'cart_item')) == 0
    print_with_timestamp ('Test Remove Items from cart Success.')

def run_tests():
    print_with_timestamp('Starting the test...')
    driver = create_driver()
    print_with_timestamp('Test: Login with standard_user')
    login(driver, 'standard_user', 'secret_sauce')
    print_with_timestamp('Test: Add items to cart')
    add_items_to_cart(driver)
    print_with_timestamp('Test: Remove items from cart')
    # input("Press Enter to close the browser...")
    remove_items_from_cart(driver)
    print_with_timestamp("UI Tests completed.")
    
    driver.quit()

if __name__ == "__main__":
    run_tests()
