import matplotlib.pyplot as plt
import numpy as np
from sklearn import datasets, svm, metrics, model_selection

digits = datasets.load_digits()
n_digits = len(digits.images) # save the number of digits in a variable
print('No. of digits = ' + str(n_digits))

#plt.ion() # turn on interactive plotting
#plt.imshow(digits.images[0])
#plt.title('Image 0 label=' + str(digits.target[0]))
#plt.figure()
#plt.imshow(digits.images[1500])
#plt.title('Image 1500 label=' +str(digits.target[1500]))

flat_digits = digits.images.reshape((n_digits,-1))
acc_array = np.zeros(10)
train_idx_len_array = np.zeros(10, dtype=int)

for x in range(0, 10):
    N_split = n_digits//(x+2) # recall // is integer division
    train_idx = np.arange(0, N_split)
    test_idx = np.arange(N_split, n_digits)
    #print(train_idx)
    #print('Length of training array = ' + str(len(train_idx)))
    train_idx_len_array[x] = len(train_idx)

    dig_train = flat_digits[train_idx] # data
    label_train = digits.target[train_idx] # target labels

    digit_svn = svm.SVC(gamma = 0.005)
    digit_svn.fit(dig_train, label_train)
    est = digit_svn.predict([flat_digits[1000]])
    #print('Digit 1000: classified ' + str(*est) + ' actual ' + str(digits.target[1000]))
    est = digit_svn.predict([flat_digits[1500]])
    #print('Digit 1500: classified ' + str(*est) + ' actual ' + str(digits.target[1500]))

    flat_test = flat_digits[test_idx]
    label_test = digits.target[test_idx]
    label_pred = digit_svn.predict(flat_test)

    label_comp = (label_test == label_pred)

    acc = np.sum(label_comp)/len(label_comp)
    #print ('Accuracy = ' + str(acc))
    acc_array[x] = acc*1000

#print(acc_array)
#print(train_idx_len_array)

plt.plot(acc_array, train_idx_len_array)
plt.title("Graph of Size of test array vs. Accuracy")
plt.xlabel("Accuracy (out of 1000)")
plt.ylabel("Size of test array")
plt.show()

#ex_idx = np.argmin(label_comp)
#orig_idx = ex_idx + N_split
#plt.figure()
#plt.imshow(digits.images[orig_idx])
#plt.title('Failed id ' + str(orig_idx) + ': actual- ' + str(digits.target[orig_idx]) + ' classify- ' + str(label_pred[ex_idx])) 
